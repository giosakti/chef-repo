# Chef Repo for Barito Flow

Infrastructure as a code.

## Setup

* `bundle install`
* Bootstrap chef (1st time) : `knife solo bootstrap user@host nodes/xxxxxx.json`
* Running recipe : `knife solo cook user@host nodes/yyyyyy.json`
