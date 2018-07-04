# Running with Docker

```
$ docker build -t my-ruby-app .
$ docker run -it --name my-running-script my-ruby-app
```

You should see the cucumber tests pass

# Developing locally

- Install ruby `2.5`. The suggested way to install ruby locally on your system is via rbenv.
- Once you have ruby in your path, install bundler with `gem install bundler`
- Run `bundle install` in this directory
- Run the cucumber tests using the `bundle exec cucumber` command
