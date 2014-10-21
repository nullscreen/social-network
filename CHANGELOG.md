# Changelog

All notable changes to this project will be documented in this file.

For more information about changelogs, check
[Keep a Changelog](http://keepachangelog.com) and
[Vandamme](http://tech-angels.github.io/vandamme).

## 0.1.0 - 2014-10-13

* Initial release with `Twitter::User` supporting `find_by`, `find_by!` and `where`.

## 0.1.1 - 2014-10-16

* [FEATURE] Add `Instagram::User` supporting `find_by` and `find_by!`.

## 0.2.0 - 2014-10-20

**How to upgrade**

If your code never calls the `followers_count` method on a `Twitter::User`, then you are good to go.
If it does, then replace your calls to `followers_count` with `follower_count` (singular).

* [ENHANCEMENT] Use the same `follower_count` name both for Twitter and Instagram users.

## 0.2.1 - 2014-10-20

* [ENHANCEMENT] Requiring 'net' auto-loads Net::Twitter and Net::Instagram.

## 0.2.2 - 2014-10-21

* [ENHANCEMENT] Twitter::User.find_by! raises Net::HTTPServerException 404
"Not Found" when a user is not found and Net::HTTPServerException 403
"Forbidden" when a user is suspended. These are the original errors received
from the Twitter API.
