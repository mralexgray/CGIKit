# CGIKit 7

The next breakthrough in Web bevelopment

# Introduction

This is the 7th design of CGIKit. All previous version focuses on designing a
library that is used to build a (Fast)CGI application. Alter almost three years
hitting rock ends, I am changing the design concept.

CGIKit 7 has three components:

*   A server plugin that passes requests from different servers to the web core,
*   A web core that processes requests, and
*   Libraries for writing both webapplications and server plugins.

This project includes those modules:

*   Libraries:
    *   `CGIKit.framework`: Library for writing the Web applications.
    *   `CGIServer.framework`: Library for writing server plugins.
*   The CGIKit Execution Coordinator daemon `cgicoordd`
*   Server plugins:
    *   `mod_objc`: Module for Apache httpd 2.2-2.4
    *   `objc_fcgid`: FastCGI interface for nginx, lighttpd, etc
*   The lightweight Web server `ochttpd`, for debugging

# License & Contact

Please view [our license here.](LICENSE.md) It is roughly a three-clause BSD
license.

If you want to contact the owner of the project, please send Email to Maxthon
Chan &lt;<xcvista@me.com>&gt;
