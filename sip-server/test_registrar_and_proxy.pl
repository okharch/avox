use strict;
use warnings;
use Net::SIP;

# This is a simple registrar + proxy which listens on 192.168.178.2
# for requests. Anybody can register with any address and if somebody
# invites somebody using over this proxy it will first check if the
# target address is locally registered and in this case forward the
# invitation to the registered party. Otherwise it will try to resolve
# the target using DNS and forward the request.
#
# Because it accepts any registration w/o passwords it's good for testing
# but don't use it in production

my $server_addr = '192.168.154.128:5060';
my $ua = Net::SIP::Simple->new( leg => $server_addr );
$ua->create_chain([
	$ua->create_registrar,
	$ua->create_stateless_proxy, 
]);
print "Listen to $server_addr\n";
$ua->loop;
