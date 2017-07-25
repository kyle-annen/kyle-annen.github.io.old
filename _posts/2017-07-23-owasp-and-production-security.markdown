---
layout: post
title:  "OWASP and Production Security"
date:   2017-07-23 12:00:00 -0500
categories: ruby rails security owasp
excerpt_separator: <!--more-->
---

![wwguards]({{ site.url }}/assets/wwguards.jpg)

Welcome to the Wild West.  After spending some time learning about the simplest of web security pitfalls, I have come to the conclusion that there are still gunslingers roaming our virtual wagon tracks. Saddle up, grab a copy of the [OWASP Top 10][owasptop10], and let's chase these would-be website wranglers back to the hills.

<!--more-->

We like to think the rapid advancements of web frameworks comes hand in hand with a secure website.  While this is true, if the frameworks are not kept up to date and if the developers working on the products are not familiar with common security missteps, simple mistakes are sure to be repeated.

Every year OWASP, The Open Web Application Security Project, releases the [OWASP Top 10][owasptop10] which examines the top 10 threats in web security.  Comparing the Top 10 Lists from 2013 and 2017 shows that the majority of top threats remain on the list through the four year period. In all, only two new issues have made the 2017 version, and two of the previous items where combined into one in order to make room.

That would have to mean that these are difficult and tricky risks to find, assess, and fix.  Not the case, coming in at number 5 is Security Misconfigurations, which it as simple as leaving the default accounts and passwords on the production database or storing secrets and salts in plain text on the server.  

I have compiled a quick list of the issues I have seen in the past weeks, a far cry from the extensive tools, cheat sheets, and guides available from the incredibly dedicated individuals who contribute to the OWASP every years. Please visit [OWASP's Wiki here][owaspwiki] to read the amazing information to help you escape the current Wild West of the World Wide Web.

# 1. Unsafe String Interpolation

Frameworks all have safe ways to escape user input, please use them.  The vast majority of websites are user interactive, it is vitally important that any input from a user is escaped prior to placing into your websites views.  As a general rule, use safe string interpolation whenever any data from user input is shown in the broswer.

# 2. Use Framework or Language Libraries, Not Command Line Tools

While it may be tempting to run command line tools from your project, it is best to use built-in file tools that come with your framework du jour. Ruby has file tools, Python has file tools, Elixir currently has 16 file and directors libraries available. 

If any command line operations are executed by your web app, it is possible and probable that someone to name a file upload to be ```rm -rf .``` and wipe a portion of the file server. 

While we are at it, please rename all uploaded files to a hash and store the escaped name in the database.  

# 3. Don't Store Passwords in Plain Text, and Have Password Standards

Eight character passwords with numbers are now considered weak.  At least 10 characters with uppercase, lowercase, numbers and special characters is needed for a password to be up to snuff. 

Passwords should never be stored in plain text, and they all should not use the same salt.  This is exactly why there are 27 records of my email address and past passwords online at this moment.  Yes, I have had the password since before Gmail was widely available (you had to be invited).

# 4. Change Default Passwords and Don't Keep Secrets or IDs in Plain Text

Even if you are testing out a public deployment for testing, and even if it is just on Heroku or AWS with no DNS or robots.txt, if a production-like configuration is left with defaults in place, it is possible and probable that it could make it to deployment for real. 

# 5. Authentication is Not Authorization

Ensure that all pages of your website have authorization checks, even if this is to explicitly allow open access. Getting in the habit of specifying authorization will prevent broken access control.  Seems like a no-brainer, but if it is not practiced it will be overlooked.

# 6. Unprotected APIs

APIs are integral and necessary in order to share data across mobile apps and websites. The same levels of security are needed in APIs and more. Unique tokens should be sent on each request, so that interceptions can not have lasting effects.  

It is also important to examine the level of data stored in a session cookie to keep all risks at a minimum. 

Again, maybe this level of information may not be very new, but hopefully the commonality of the issues raises someones curiosity and leads to more inspection of our common fallacies.






[owaspwiki]:https://www.owasp.org/index.php/Main_Page
[owasptop10]: https://github.com/OWASP/Top10/raw/master/2017/OWASP%20Top%2010%20-%202017%20RC1-English.pdf