# Radatracer

[![pipeline status](https://gitlab.com/1ma/radatracer/badges/master/pipeline.svg)](https://gitlab.com/1ma/radatracer/pipelines)

[Jamis Buck's Raytracer Challenge](https://pragprog.com/titles/jbtracer/the-ray-tracer-challenge/) implemented in Ada.


## Project Structure

### lib/

The meat of the ray tracer is written as standalone Ada packages that are bundled in a static library (`libradatracer.a`).

Each package maps roughly to one chapter of the book (some packages are iterated upon on subsequent chapters).

The library can be built with a GNAT toolchain and GPRBuild: `gprbuild lib/radatracer.gpr`

### bin/

A collection of driver programs that are linked to `libradatracer.a` and use its functionality in several ways.

Each program maps roughly to the capstone exercises of each chapter (again, some programs are iterated upon).

As the library, these programs only need GPRBuild and a GNAT toolchain to build them: `gprbuild bin/capstones.gpr`

### tests/

An [AUnit](https://alire.ada.dev/crates/aunit) test suit that exercises `libradatracer.a`

To build the test suite you also need [Alire](https://alire.ada.dev/) as well as GNAT and GPRBuild: `cd tests; alr build`
