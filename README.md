# vice
[![Build Status](https://travis-ci.org/knarka/vice.svg?branch=master)](https://travis-ci.org/knarka/vice)
[![Gem Version](https://badge.fury.io/rb/vice-editor.svg)](https://badge.fury.io/rb/vice-editor)

vice (**vi**sual **c**ode **e**ditor) is a small vi-like editor. It is currently still a work in progress.

## Installation
Simply running `gem install vice-editor` should be sufficient to install vice. You can then execute `vice` to start the editor.

## Configuration
vice can be configured by creating a file at `~/.vicerc`. Your `.vicerc` should be a YAML file containing keys and fitting values as found in [constants.rb](https://github.com/knarka/vice/blob/master/lib/vice/constants.rb#L2). For an example, please look at [the example .vicerc files](https://github.com/knarka/vice/blob/master/extras) in this repository.

## Development
Running: `rake`.

Tests: `rake test`.

Style: `rake style`.
