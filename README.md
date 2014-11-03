# PrEngine

This is a mountable rails engine that gathers view counts for each instance in redis and saves them into mongodb.

### Features

* Periodically saves sum of view count to mongodb
* View helper for an instance
* Daily / Weekly / Monthly / GeoNear
* Chart helper using [d3](https://github.com/mbostock/d3)
* gather SNS share #

> Supported Browsers for charts(d3 runs best on WebKit based browsers)

> * Google Chrome: latest version (preferred)
> * Opera 15+ (preferred)
> * Safari: latest version
> * Firefox: latest version
> * Internet Explorer: 9 and 10


***

### Generator (WIP)

* add //= require pr_engine in application.js
* usage for helpers
* usage for including countable
* mounting this engine
* [How To Gemify Your Own Assets](http://zurb.com/article/814/yetify-your-rails-new-foundation-gem-and-)

***

### D3.js resources

#### Official
* [Official site](http://d3js.org/)
* [Official API Reference](https://github.com/mbostock/d3/wiki/API-Reference)
* [Official Plugins](https://github.com/d3/d3-plugins)
* [d3.geo.tile](http://bl.ocks.org/mbostock/4132797)
* [d3-geo-projection](https://github.com/d3/d3-geo-projection/)

#### Book

* [Interactive Data Visualization for the Web <- free, online!!](http://chimera.labs.oreilly.com/books/1230000000345/index.html)

#### related Blogs / Tutorials

* [Wiki - Tutorial list](https://github.com/mbostock/d3/wiki/Tutorials)
* [D3.JS: HOW TO HANDLE DYNAMIC JSON DATA](http://pothibo.com/2013/09/d3-js-how-to-handle-dynamic-json-data/)

***

### License

MIT-LICENSE


