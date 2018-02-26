class dns::record (
  Optional[Hash] $a     = undef,
  Optional[Hash] $aaaa  = undef,
  Optional[Hash] $cname = undef,
  Optional[Hash] $mx    = undef,
  Optional[Hash] $ns    = undef,
  Optional[Hash] $srv   = undef,
  Optional[Hash] $txt   = undef,
  Optional[Hash] $ptr   = undef
) {

  if $a {
    create_resources('dns::record::a', $a)
  }

  if $aaaa {
    create_resources('dns::record::aaaa', $aaaa)
  }

  if $cname {
    create_resources('dns::record::cname', $cname)
  }

  if $mx {
    create_resources('dns::record::mx', $mx)
  }

  if $ns {
    create_resources('dns::record::ns', $ns)
  }

  if $srv {
    create_resources('dns::record::srv', $srv)
  }

  if $txt {
    create_resources('dns::record::txt', $txt)
  }

  if $ptr {
    create_resources('dns::record::ptr', $ptr)
  }
}
