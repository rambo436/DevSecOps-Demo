# opensource ruby ruby

This is hardened docker image built specifically to be made as a contribution to the DSOP/dccscr project found [here](https://dccscr.dsop.io/dsop/dccscr).

# v2.6.5
This package includes Ruby Versrion 2.6.5. This container is still a work in progress and will be submitted for review in a few days.

# Building the image
1. In a terminal, navigate to the ruby 2.6.5 working directory (DevSecOps-Demo/hardened-docker/ruby/v2.6.5)
   Example: `cd ~/DevSecOps-Demo/hardened-docker/ruby/v2.6.5/`
2. Execute the demo-bootstrap.sh from the working directory to download artifacts and build/tag the docker image.
   `./demo-bootstrap.sh
3. Run the image with `docker run -it moonrake-docker-ruby:demo`

4. You can exit out of the image by typeing `exit` then press the return key.

# Previous Commit Log from DSOP/dccscr repository:
commit 469269c30c4053bb1a6e9662b02b72b57e6d7746 (HEAD -> feature/ruby)
Author: Kai Prout <kai@moonrake.it>
Date:   Wed Oct 16 15:47:29 2019 -0400

    Installing development dependencies and adding flags to minimize ruby installation..

commit cbe0f12698cc8551d3e05711e5562f6547e80569
Author: Kai Prout <kai@moonrake.it>
Date:   Wed Oct 16 15:46:04 2019 -0400

    Removing tarfile per bill of materials.

commit 92e0575c23f00f92157b111b8d1b46e545b4729e
Author: Kai Prout <kai@moonrake.it>
Date:   Wed Oct 16 14:56:29 2019 -0400

    Updating dockerfile to build and installruby from the included tar file.

commit b562dbc369b0903be3bc5045508679cefda8bb31
Author: Kai Prout <kai@moonrake.it>
Date:   Wed Oct 16 14:54:50 2019 -0400

    Adding src/ruby-2.6.5.tar

commit 58c2df38ec2712230ff8fd00eb2919639d019b78
Author: Kai Prout <kai@moonrake.it>
Date:   Wed Oct 16 12:59:40 2019 -0400

    Generating compliant directory structure for ruby container images.
