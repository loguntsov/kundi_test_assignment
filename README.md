# Kundi Test Assignment

See `/docs/requirements.txt`

## Installation

Just use ``make`` to get everything.

Starting in interactive console:
```make run```

Starting as daemon ```make start```
Stop daemon ```make stop```

# Usage

Just run server and open [http://localhost:8080](http://localhost:8080)

You can use GET-params to assign name of hero: [http://localhost:8080?name=hero](http://localhost:8080?name=hero)

The default name is alex.

# Make commands

* `make all' -- build everything
* `make compile` -- compilation of sources
* `make docs` -- making docs
* `make release` -- creation of release
* `make start` -- start as daemon
* `make stop` -- stop daemon
* `make run` -- start in console in interactive mode
* `make clean` -- clean everything
* `make test` -- launch tests

# Author

Sergey Loguntsov <loguntsov@gmail.com>