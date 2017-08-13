# Namikoda
[![Build Status](https://travis-ci.org/namikoda/namikoda-puppet.png?branch=master)](https://travis-ci.org/namikoda/namikoda-puppet)

#### Table of Contents

1. [Description](#description)
1. [Compatibility](#compatibility)
1. [Getting Started](#getting-started-with-namikoda)
    * [Go get an API key](#go-get-an-api-key)
    * [Set the key](#set-the-key)
1. [Usage - Configuration options and additional functionality](#usage)
    * [ipv4sfor](#ipv4sfor)
    * [ipv6sfor](#ipv6sfor)
    * [value](#value)
    * [puppetlabs/firewall integration](#puppetlabsfirewall-integration)
1. [More Information](#more-information)
1. [Development](#development)

## Description

### IP range management in the cloud, made easy

Namikoda provides an easy interface for getting configuration values consistent across your physical and cloud infrastructure. We focus on providing IP range data and the tooling to act on it. Confidently use human-readable tags instead of lists of IPs in your configuration.

This module is an interface between puppet and the Namikoda API.

## Compatibility

This module was developed against Puppet 4.  It's unlikely to work with any prior version.

## Getting started with Namikoda

### Go get an API key

If you haven't yet, generate an API key at https://manage.namikoda.com.  See the [registration documentation](https://docs.namikoda.com/registration/index.html) for the step-by-step process.

### Set the key

Once you have an API key, add a line in your `sites.pp` or equivalent to tell the namikoda library what it is.

```puppet
namikoda::set_apikey("aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee")
```

That will let the library set the right headers in the REST calls.

## Usage

### Functions

#### ipv4sfor

The `namikoda::ipv4sfor()` function takes one parameter, the ID of the site that you're trying to get the IPs for.  It returns an array of strings.  Each string is a CIDR-encoded IPv4 range.

```puppet
notice (namikoda::ipv4sfor('github'))
# Logs [ 185.199.108.0/22, 192.30.252.0/22 ]
```

#### ipv6sfor

The `namikoda::ipv6sfor()` function takes one parameter, the ID of the site that you're trying to get the IPs for.  It returns an array of strings.  Each string is a CIDR-encoded IPv6 range.

```puppet
notice (namikoda::ipv6sfor('github'))
# Logs [ 2620:112:3000::/44 ]
```

#### value
The `namikoda::value()` function takes one parameter, the ID of the site that you're trying to get the IPs for.  It returns an array of strings.  Each string is a CIDR-encoded IP range, combining both the IPv4 and IPv6 ranges above.

```puppet
notice (namikoda::value('github'))
# Logs [ 185.199.108.0/22, 192.30.252.0/22, 2620:112:3000::/44 ]
```


### puppetlabs/firewall integration

This module integrates well with [puppetlabs/firewall](https://forge.puppet.com/puppetlabs/firewall).  Assuming that the firewall module is imported, you can iterate over the ranges returned by one of the functions above and create rules as you see fit.

For example:
```puppet

each( namikoda::ipv4sfor('github') ) |$subnet| {
  firewall { "006 Allow inbound HTTP from github webhook subnet $subnet":
    dport    => 80,
    proto    => tcp,
    action   => accept,
    source   => $subnet,
  }
}
```

## More information

See https://docs.namikoda.com for more detailed information about Namikoda and what sites are available.

## Development

We love PRs!  Head over to https://github.com/namikoda/puppet and fork away.
