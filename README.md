![Decoration](https://user-images.githubusercontent.com/3743321/40796764-6dcdf06a-6506-11e8-9fc2-c555ed907192.png)

<p align="center">
  <img width="60" height="50" src="https://cdn.jsdelivr.net/gh/juliendargelos/count@ed294754/app/assets/images/logo.svg">
</p>
<h2 align="center">C&nbsp;&nbsp;&nbsp;&nbsp;O&nbsp;&nbsp;&nbsp;&nbsp;U&nbsp;&nbsp;&nbsp;&nbsp;N&nbsp;&nbsp;&nbsp;&nbsp;T<br><br></h2>

<p align="center">
  Count is a personal Rails application for managing freelance projects.
</p>

<p align="center">
  <a href="https://codeclimate.com/github/juliendargelos/count/maintainability"><img src="https://api.codeclimate.com/v1/badges/55a966ec5ea3d126955f/maintainability" alt="Maintainability"></a>
</p>

<p align="center">
  <a href="https://heroku.com/deploy?template=https://github.com/juliendargelos/count"><img src="https://www.herokucdn.com/deploy/button.svg" alt="Deploy"></a>
</p>

## Install

### Clone the repository

```shell
git clone git@github.com:juliendargelos/count.git
cd count
```

### Check your Ruby version

```shell
ruby -v
```

The ouput should start with something like `ruby 2.5.1`

If not, install the right ruby version using [rbenv](https://github.com/rbenv/rbenv) (it could take a while):

```shell
rbenv install 2.5.1
```

### Install dependencies

Using [Bundler](https://github.com/bundler/bundler) and [yarn](https://github.com/yarnpkg/yarn):

```shell
bundle && yarn
```

### Initialize the database

```shell
rails db:create db:migrate
```

### Add heroku remote

Using [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli):

```shell
# Replace by your own remote
heroku git:remote -a count-juliendargelos
```

## Serve

```shell
rails s
```

## Deploy

Push to Heroku production remote:

```shell
git push heroku
```
