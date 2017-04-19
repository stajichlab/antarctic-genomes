#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;

# for mapping updated scaffolded assembly based on Satsuma + mercator scaffolded back to an NCBI AGP file
# needs more explanation....
my $acc = 'NAEU01_accs';
my $map = 'Rsp_CCFEE5018.Satsuma_scaf.agp';

GetOptions('a|acc:s' => \$acc,
	   'm|map:s' => \$map);

open(my $fh => $acc) || die $!;
my %scaf2acc;
while(<$fh>) {
 next if /^\-/ || /^Contig id\s+Accession/;
 my ($ctg,$acc) = split;
 $scaf2acc{$ctg} = $acc;
}
 
open($fh => $map) || die $!;
my %count;
while(<$fh>) {
 chomp;
 my @row = split;
 if( $row[4] eq 'D') {
    $row[4] = 'W';
   if ( exists $scaf2acc{$row[5]} ) {
      $row[5] = $scaf2acc{$row[5]};
   } elsif( $row[5] =~ s/^(\S+)_(contig|scaffold_\d+)/$2/ &&
	 exists $scaf2acc{$row[5]} ) {
	$row[5] = $scaf2acc{$row[5]};
   } else {	
	warn("unknown scaffold $row[0] -- skipping \n");
        next
   }
   if( $row[0] =~ s/^(\S+)_(contig|scaffold_\d+)/$2/ && 
	exists $scaf2acc{$row[0]} ) {
	$row[0] = $scaf2acc{$row[0]};
   } elsif ( $row[0] =~ s/assembled(\d+)/Supercontig_$1/ ) {
	# replacing with Supercontig
   }
  } elsif( $row[4] eq 'N' ) { $row[4] = 'U';
	$row[6] = 'scaffold';
	$row[8] = 'align_xgenus';
	$row[0] =~ s/assembled(\d+)/Supercontig_$1/;
  }
 $row[3] = ++$count{$row[0]};
 print join("\t", @row),"\n";
}
