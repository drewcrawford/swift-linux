# swift

This is the smallest Swift Docker image that I know how to make.  I use this image as a production base for Swift language projects.

## Rationale

The "supported" Swift configuration is Ubuntu.  However, I run Debian, and prefer more minimal Docker images in general.  So, I set out to create a "proper" minimal Debian image.

## Use

Just pull from drewcrawford/swift.  It's installed to `/usr/local`.

## Build

You can build with `docker build .`.  You may want to up the number of cores if you're using VirtualBox, because it takes a long time single-threaded.

### Source

Here's a riddle: if sourcecode exists on GitHub, and nobody compiles it, is the project open-source?

Answer: We compile it.  So I don't know.

The Swift build system is kind of convoluted, and building an installable package is not documented anywhere (that I can find anyway).  I guess we'll give clattner a pass for being awesome otherwise, but it is hairy.

I dove into the build system, and worked out what (I think) they do to build a tarball, and here it is!  This image should build, run, test, and validate Swift exactly as upstream does.  Then we just turn around and install that tarball to `/usr/local`.

Since we build from source, you could modify this image to apply your own custom patches before building if you like.  As such this Dockerfile may be useful as a reference for a workflow for developing Swift itself.

## FAQ

### Q: Can't you use Alpine?

A: [No.](https://lists.swift.org/pipermail/swift-users/Week-of-Mon-20151228/000653.html)

### Q: How large is this image?

A: 472.2 MB, at the time of this writing.  125.1 of that is Debian, so the delta of Swift itself is 347.1MB.

We uninstall all the build dependencies, so I don't know how to make it smaller.

### Q: Do I need this image to run Swift binaries?

A: Probably not.  You really only need this image to build Swift programs.  You should use a volume or a `docker cp` to move the built products into your own image, that does not have Swift installed, for distribution.