#!/usr/bin/perl

use strict;
use warnings;
use List::Util qw(max);

my $argument = shift @ARGV;

if($argument eq 'every_jpg_has_nonempty_pdf') {
	my $dir = '.';

	opendir(DIR, $dir) or die $!;

	while (my $file = readdir(DIR)) {
		next if ($file =~ m/^\./);
		next unless $file =~ m#\.jpg$#;

		my $pdf = $file;
		$pdf =~ s#\.jpg$#.pdf#g;

		print "$file -> $pdf\n";

		if(-e $pdf) {
			my $size = -s $pdf;
			if($size == 0) {
				exit 1;
			}
		} else {
			exit 1;
		}

		if(-e $pdf && -s $pdf == 0) {
			exit 1;
		}
	}

	closedir(DIR);

	exit 0;
} elsif ($argument eq "is_blank") {
	my $file = shift @ARGV;

	if(!-e $file) {
		warn "$file not found";
		exit 0;
	}

	my $skip = skip_file($file);

	if($skip) {
		warn "$file seems empty. Moving it\n";
		exit 0;
	} else {
		warn "$file seems non-empty. Not moving it\n";
		exit 1;
	}

	sub skip_file {
		my $file = shift;
		my $command = 'convert '.$file.' -threshold 30% -format %c histogram:info:- | wc -l';
		my $code = qx($command);

		chomp $code;

		if($code > 1) {
			return 0;
		} else {
			return 1;
		}
	}
} elsif ($argument eq "not_ready_for_new_forks") {
	my $max = 5;

	my $empty_files = qx(find . -type f -empty -print | wc -l);
	chomp $empty_files;
	if($empty_files <= $max) {
		exit 1;
	} else {
		exit 0;
	}
} elsif ($argument eq "get_start_pdf") {
	my $dir = '.';

	my $start = 1;

	my @files = ();
	opendir(DIR, $dir) or die $!;

	while (my $file = readdir(DIR)) {
		next if ($file =~ m/^\./);
		next unless $file =~ m#\.jpg$#;

		if($file =~ m#out(\d+)\.jpg#) {
			push @files, $1;
		}
	}

	closedir(DIR);

	my $max = max(@files) // 0;
	$start = $max + 1;

	print $start;
} else {
	die "ERROR: Unknown parameter $argument";
}
