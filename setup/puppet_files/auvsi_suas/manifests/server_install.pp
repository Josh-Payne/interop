# AUVSI SUAS Puppet Module: server_install
# Installs suas server, plus dependencies
# ==============================================================================

class auvsi_suas::server_install {
    require auvsi_suas::base

    # Install packages from apt.
    $package_deps = [
        "python-numpy",
        "python-scipy",
        "python-matplotlib",
        "python-psycopg2",
        "npm",
    ]
    package { $package_deps:
        ensure => "latest",
    }

    # Create server virtualenv
    python::virtualenv { '/interop/server/venv' :
        ensure => 'present',
        version => 'system',
        requirements => '/interop/server/requirements.txt',
        # We install some packages from apt since that is much faster.
        systempkgs => true,
        require => [ Package['python-numpy'], Package['python-scipy'],
                     Package['python-matplotlib'], Package['python-psycopg2'] ]
    }

    # Install packages from NPM.
    exec { 'npm install karma and jasmine':
        command => "npm install -g karma karma-jasmine karma-chrome-launcher karma-cli",
        cwd => "/interop/server",
        require => Package['npm'],
    }
}
