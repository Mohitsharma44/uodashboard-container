# uodashboard-container
UODashboard in a container form

[![Build Status](https://travis-ci.org/Mohitsharma44/uodashboard-container.svg?branch=master)](https://travis-ci.org/Mohitsharma44/uodashboard-container)
[![Docker Build](https://img.shields.io/docker/build/mohitsharma44/uodashboard-container.svg)](https://img.shields.io/docker/build/mohitsharma44/uodashboard-container.svg)

This repo contains the container version of [UODashboard](https://github.com/Mohitsharma44/uodashboard) webapplication.

>[**Update: Jan 2018**]:
>
>To sync timelapse videos, I now use a rsyncd container [my_rsyncd](https://github.com/Mohitsharma44/my_rsyncd). This container should be started before running uo-dashboard container.

This container can, ofcourse, run as is but the main reason for creating a separate repo is to configure and orchestrate this using kubernetes. More info can be found in [kubernetes-playground](https://github.com/Mohitsharma44/kubernetes-playground/tree/master/webapp) repo.

This image is also hosted on dockerhub [mohitsharma44/uodashboard-container](https://hub.docker.com/r/mohitsharma44/uodashboard-container/) and can be pulled directly from there if you don't want to build it.
