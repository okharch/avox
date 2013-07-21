#!/usr/bin/perl -w
use strict;
use warnings;
use Avox::Db;

$\="\n";

unless (sql_value("select count(*) from clerks")) {
    
    print "add some clerks to db...";
    
    inserts("insert into clerks(clerk_type_id,clerk_status_id,name,first_name,last_name,
    phones,mails,address,login,passwd)",
    [map [1,2,($_) x 8],1..100]
    );
    
}

unless (sql_value("select count(*) from clients")) {
    
    print "add some clients...";
    
    inserts(q{insert into clients(
client_type_id,
client_status_id,
clerk_id_change,
name,
phones,
mails,
address,
login,
passwd
)},
    [map [1,2,1,($_) x 6],1..100000]
    );

}
