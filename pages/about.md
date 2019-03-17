---
layout: page
title: About
description: Technology changes our life
keywords: Robin Ye
comments: true
menu: About
permalink: /about/
---

If you haven't found what you loved, keep Looking，Don’t Settle.

You can't connect the dots looking forward.You can only connect them looking backwards.

So you have to trust that the dots will somehow connect in your future.

## Contact

{% for website in site.data.social %}
* {{ website.sitename }}：[@{{ website.name }}]({{ website.url }})
{% endfor %}

## Skill Keywords

{% for category in site.data.skills %}
### {{ category.name }}
<div class="btn-inline">
{% for keyword in category.keywords %}
<button class="btn btn-outline" type="button">{{ keyword }}</button>
{% endfor %}
</div>
{% endfor %}
