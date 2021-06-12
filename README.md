# Radatracer

[![pipeline status](https://gitlab.com/1ma/radatracer/badges/master/pipeline.svg)](https://gitlab.com/1ma/radatracer/pipelines)

[Jamis Buck's Raytracer Challenge](https://pragprog.com/titles/jbtracer/the-ray-tracer-challenge/) implemented in Ada.

<div align="center">
  <img alt="best render yet" src="https://i.imgur.com/bu70Vus.png">
</div>


## Project Goals and Current Status

### Core Functionality (Book Chapters)

- [X] Chapter 1: Tuples, Points and Vectors
- [X] Chapter 2: Canvas and PPM serialization
- [X] Chapter 3: Matrices
- [X] Chapter 4: Matrix Transformations
- [X] Chapter 5: Ray-Sphere Intersections
- [X] Chapter 6: Point Lights and Phong Shading
- [X] Chapter 7: World and Camera (aka "Making a Scene")
- [X] Chapter 8: Shadows
- [X] Chapter 9: Planes
- [ ] Chapter 10: Patterns
- [ ] Chapter 11: Reflection and Refraction
- [ ] Chapter 12: Cubes
- [ ] Chapter 13: Cylinders and Cones
- [ ] Chapter 14: Groups
- [ ] Chapter 15: Triangles and OBJ format parsing
- [ ] Chapter 16: Constructive Solid Geometry

### Bonus

- [ ] YAML scene loader
- [ ] Render the cover of the book
- [ ] [Area Lights, aka Soft Shadows](http://www.raytracerchallenge.com/bonus/area-light.html)
- [ ] [Texture Mapping](http://www.raytracerchallenge.com/bonus/texture-mapping.html)
- [ ] Final Boss: Render [bust of Date Masamune](https://sketchfab.com/3d-models/date-masamune-73ae98ad60874ad49cb1e2decbab6393)

### Optimizations

- [X] Cache inverted transformation matrices
- [ ] [Buffered implementation of Print_PPM](https://gitlab.com/1ma/radatracer/-/issues/8)
- [ ] [Bounding Boxes and Hierarchies](http://www.raytracerchallenge.com/bonus/bounding-boxes.html)
- [ ] [Concurrent Rendering with Tasking](https://gitlab.com/1ma/radatracer/-/issues/16)

### Ada-specific Goals

- [X] Reach a comfy development flow in Ada
- [X] Debug with `gdb`
- [ ] Profile with `gprof`
- [X] TDD with [AUnit](https://www.adacore.com/documentation/aunit-cookbook)
- [X] Grok GPRBuild and Alire
- [X] Grok Spec/Body code division and layout
- [ ] [Grok Buffered IO](https://www.adacore.com/gems/gem-39)
- [X] Grok Contracts (Pre, Post, Invariant, Predicate aspects)
- [ ] Grok Access Types, including heap allocation and deallocation
- [X] Grok Containers
- [X] Grok OOP
- [ ] Grok Tasking and Concurrency
- [X] Set Up Dockerized Continuous Integration
- [ ] Set Up Code Coverage as part of CI/CD
- [ ] Build `gnatprove` for FSF GNAT
- [ ] [Grok SPARK 2014](https://learn.adacore.com/courses/intro-to-spark/index.html)
- [ ] Set Up "Continuous Proving" as part of CI/CD
- [ ] Restrict as many language features as feasible like [libFFA](http://www.loper-os.org/?p=1913) does
- [ ] Go completely off the heap (may be next to impossible)


## Project Structure

### lib/

The meat of the ray tracer is written as standalone Ada packages that are bundled in a static library named `libradatracer.a`.

Each package maps roughly to one chapter of the book (some packages are iterated upon on subsequent chapters).

The library can be built with a GNAT toolchain and GPRBuild: `gprbuild radatracer.gpr`
This will produce `out/libradatacer.a`

### bin/

A collection of "driver programs" that are linked to `libradatracer.a` and use its functionality in several ways.

Each program maps roughly to the capstone exercises of each chapter (again, some programs are iterated upon).

To build the executables you also need [Alire](https://alire.ada.dev/) as well as GNAT and GPRBuild: `alr build`
The executables appear under `out/`.

Altenatively you can use Alire to just download the only dependency of the project (AUnit) with `alr clean`.
After the `alire/` directory is created you can build the driver programs with GPRBuild, too: `gprbuild executables.gpr`

### tests/

The test packages of an [AUnit](https://alire.ada.dev/crates/aunit) test suite that exercises `libradatracer.a`

The driver program for the test suite is one of the main executables mentioned above, `bin/aunit_harness.adb`, so
it builds as part of the "driver program" collection.


## Continuous Integration

A Gitlab pipeline builds the project and passes the tests with FSF GNAT 10.2 and 9.3 in a dockerized Ubuntu environment.

The `1maa/fsf-gnat` image used in the pipeline is generated from [this Dockerfile](https://gitlab.com/1ma/dockertronics/-/blob/master/gnat/9/Dockerfile).
