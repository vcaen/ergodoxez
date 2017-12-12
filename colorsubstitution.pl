#!/usr/bin/perl

use strict;
use warnings;
use HOP::Lexer 'make_lexer';

#!/usr/bin/perl

use strict;
use warnings;
use HOP::Lexer 'make_lexer';

my $sql = <<END_SQL;
select the_date as "date",
round(months_between(first_date,second_date),0) months_old
,product,extract(year from the_date) year
,case
  when a=b then 'c'
    else 'd'
      end tough_one
      from XXX
END_SQL

my @sql   = $sql;
my $lexer = make_lexer(
    sub { shift @sql },
    [ 'CASE', qr/(?i:case)/          ],
    [ 'COMMA',   qr/,/                            ],
    [ 'OP',      qr{[-=+*/]}                      ],
    [ 'PAREN',   qr/\(/,      sub { [shift,  1] } ],
    [ 'PAREN',   qr/\)/,      sub { [shift, -1] } ],
    [ 'TEXT',    qr/(?:\w+|'\w+'|"\w+")/, \&text  ],
    [ 'SPACE',   qr/\s*/,     sub {}              ],
);

sub text {
    my ( $label, $value ) = @_;
    $value =~ s/^["']//;
    $value =~ s/["']$//;
    return [ $label, $value ];
}

my $inside_parens = 0;
while ( defined ( my $token = $lexer->() ) ) {
    my ( $label, $value ) = @$token;
    $inside_parens += $value if 'PAREN' eq $label;
    next if $inside_parens || 'TEXT' ne $label;
    if ( defined ( my $next = $lexer->('peek') ) ) {
        my ( $next_label, $next_value ) = @$next;
        if ( 'COMMA' eq $next_label ) {
            print "$value\n";
        }
        elsif ( 'KEYWORD' eq $next_label && 'from' eq $next_value ) {
            print "$value\n";
            last; # we're done
        }
    }
}