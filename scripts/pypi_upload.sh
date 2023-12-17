#!/bin/bash

rm -rf build dist pwnagotchi.egg-info &&
  python3.7 setup.py sdist bdist_wheel &&
  clear &&
  twine upload dist/*
