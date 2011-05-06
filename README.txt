Developing Pressgang
====================

**If you want to build or contribute to a pressgang project, read this document.**

**This document will save you and us a lot of time by setting up your development environment correctly.**
It solves all known pitfalls that can disrupt your development.
It also describes all guidelines, tips and tricks.

If you discover pitfalls, tips and tricks not described in this document,
please update it using the [markdown syntax](http://daringfireball.net/projects/markdown/syntax).

Table of content
----------------

* **Building with Maven**

* **Developing with Eclipse**

* **Developing with IntelliJ**

* **Team communication**

* **Releasing**

* **FAQ**

Building with Maven
===================

All projects use Maven 3 to build all their modules.

Installing Maven
----------------

* Get Maven

    * [Download Maven](http://maven.apache.org/) and follow the installation instructions.

* Linux

    * Note: the `apt-get` version of maven is probably not up-to-date enough.

    * Linux trick to easily upgrade to future versions later:

        * Unzip maven to `~/opt/build`

        * Create a version-independent link:

                $ cd ~/opt/build/
                $ ln -s apache-maven-3.0.3 apache-maven

            Next time you only have to remove the link and add it to the new version.

        * Add this to your `~/.bashrc` file:

                export M3_HOME="~/opt/build/apache-maven"
                export PATH="$M3_HOME/bin:$PATH"

    * Give more memory to maven, so it can the big projects too:

        * Add this to your `~/.bashrc` file:

            export MAVEN_OPTS="-Xms256m -Xmx1024m -XX:MaxPermSize=512m"

* Windows:

    * Give more memory to maven, so it can the big projects too:

        * Open menu *Configuration screen*, menu item *System*, tab *Advanced*, button *environment variables*:

            set MAVEN_OPTS="-Xms256m -Xmx1024m -XX:MaxPermSize=512m"

* Check if maven is installed correctly.

        $ mvn --version
        Apache Maven 3.0.3 (...)
        Java version: 1.6.0_24

    Note: the enforcer plugin enforces a minimum maven and java version.

Running the build
-----------------

* Go into a project's base directory:

        $ cd ~/projects/pressgang-tools
        $ ls
        ...  pressgang-xslt pressgang-xslt-ns  pom.xml

    Notice you see a `pom.xml` file there. Those `pom.xml` files are the heart of Maven.

* **Run the build**:

        $ mvn clean install -DskipTests

    The first build will take a long time, because a lot of dependencies will be downloaded (and cached locally).

    It might even fail, if certain servers are offline or experience hiccups.
    In that case, you 'll see an IO error, so just run the build again.

    After the first successful build, any next build should be fast and stable.

Configuring Maven
-----------------

To deploy snapshots and releases to nexus, you need to add this to the file `~/.m2/settings.xml`:

     <settings>
       ...
       <servers>
         <server>
           <id>jboss-snapshots-repository</id>
           <username>jboss.org_username</username>
           <password>jboss.org_password</password>
         </server>
         <server>
           <id>jboss-releases-repository</id>
           <username>jboss.org_username</username>
           <password>jboss.org_password</password>
         </server>
       </servers>
       ...
     </settings>

More info in [the JBoss.org guide to get started with Maven](http://community.jboss.org/wiki/MavenGettingStarted-Developers).

Developing with Eclipse
=======================

Before running Eclipse
----------------------

* Do not use an Eclipse version older than `3.6 (helios)`.

Configuring the project with the m2eclipse plugin
-------------------------------------------------

The m2eclipse plugin is a plugin in Eclipse for Maven.
This is the new way (and compatible with tycho).

* Open Eclipse

* Follow [the installation instructions of m2eclipse](http://m2eclipse.sonatype.org/).

    * Follow the link *Installing m2eclipse* at the bottom.

* Click menu *File*, menu item *Import*, tree item *Maven*, tree item *Existing Maven Projects*.

* Click button *Browse*, select a repository directory. For example `~/projects/pressgang-tools`.

Configuring Eclipse
-------------------

* Set the correct file encoding (UTF-8 except for properties files) and end-of-line characters (unix):

    * Open menu *Window*, menu item *Preferences*.

    * Click tree item *General*, tree item *Workspace*

        * Label *Text file encoding*, radiobutton *Other*, combobox `UTF-8`.

        * Label *New text file delimiter*, radiobutton *Other*, combobox `Unix`.

    * Click tree item *XML*, tree item *XML Files*.

        * Combobox *Encoding*: `ISO 10646/Unicode(UTF-8)`.

    * Click tree item *CSS*, tree item *CSS Files*.

        * Combobox *Encoding*: `ISO 10646/Unicode(UTF-8)`.

    * Open tree item *HTML*, tree item *HTML Files*.

        * Combobox *Encoding*: `ISO 10646/Unicode(UTF-8)`.

    * Note: normal i18n properties files must be in `ISO-8859-1` as specified by the java `ResourceBundle` contract.

        * Note on note: GWT i18n properties files override that and must be in `UTF-8` as specified by the GWT contract.

* Set the correct number of spaces when pressing tab:

    * Warning: If you imported the `eclipse-formatter.xml` file, you don't need to set it for Java, but you do need to set it for XML anyway!

    * Open menu *Window*, menu item *Preferences*.

        * If you have project specific settings enabled instead, right click on the project and click the menu item *Properties*.

    * Click tree item *Java*, tree item *Code Style*, tree item *Formatter*.

        * Click button *Edit* of the active profile, tab *Indentation*

        * Combobox *Tab policy*: `spaces only`

        * Textfield *Indentation size*: `4`

        * Textfield *Tab size*: `4`

        * Note: If it is a build-in profile, you 'll need to change its name with the textfield on top.

    * Click tree item *XML*, tree item *XML Files*, tree item *Editor*.

        * Radiobutton *Indent using space*: `on`

        * Textfield *Indentation size*: `2`

    * Click tree item *General*, tree item *Editors*, tree item *Text Editors*.

        * Checkbox *Insert spaces for tabs*: `on`

        * Textfield *Displayed tab width*: `4`

    * Click tree item *CSS Files*, tree item *Editor*.

        * Radiobutton *Indent using space*: `on`

        * Textfield *Indentation size*: `4`

Developing with IntelliJ
========================

Configuring the project with the maven integration
--------------------------------------------------

IntelliJ has very good build-in support for Maven.

* Open IntelliJ.

* Click menu *File*, menu item *New project*.

    * Click radiobutton *Create project from scratch*, button *Next*

    * Textfield *name*: `pressgang-tools`

    * Textfield *Project files location*: `~/projects/pressgang-tools`

    * Checkbox *Create module*: `off`

* Click menu *File*, menu item *New module*

    * Radiobutton *Import from external model*, button *Next*, button *Next*

    * Textfield *Root directory*: `~/projects/pressgang-tools`

        * That is the directory that contains the multiproject `pom.xml` file from a project base directory.

    * Button *Next*, button *Next*, button *Finish*.

    * Go grab a coffee while it's indexing.

Configuring IntelliJ
--------------------

* Avoid that changes in some resources are ignored in the next run/debug (and you are forced to use mvn)

    * Open menu *File*, menu item *Settings*

    * Click tree item *Compiler*, textfield *Resource patterns*: change to `!?*.java` (remove other content)

* Set the correct file encoding (UTF-8 except for properties files) and end-of-line characters (unix):

    * Open menu *File*, menu item *Settings*

    * Click tree item *Code Style*, tree item *General*

        * Combobox *Line separator (for new files)*: `Unix`

    * Click tree item *File Encodings*

        * Combobox *IDE Encoding*: `UTF-8`

        * Combobox *Default encoding for properties files*: `ISO-8859-1`

            * Note: normal i18n properties files must be in `ISO-8859-1` as specified by the java `ResourceBundle` contract.

                * Note on note: GWT i18n properties files override that and must be in `UTF-8` as specified by the GWT contract.

* Set the correct number of spaces when pressing tab:

    * Open menu *File*, menu item *Settings*

    * Click tree item *Code Style*, tree item *General*

    * Click tab *Java*

        * Checkbox *Use tab character*: `off`

        * Textfield *Tab size*: `4`

        * Textfield *Indent*: `4`

        * Textfield *Continuation indent*: `8`

    * Open tab *XML*

        * Checkbox *Use tab character*: `off`

        * Textfield *Tab size*: `2`

        * Textfield *Indent*: `2`

        * Textfield *Continuation indent*: `4`

Team communication
==================

To develop a great project as a team, we need to communicate efficiently as a team.

* Subscribe to the RSS feeds.

    * **It's recommend to subscribe at least to the RSS feeds of the project/repostories you're working on.**

    * Prefer an RSS reader which shows which RSS articles you've already read, such as:

        * Thunderbird

            * Open menu *File*, menu item *Subscribe*.

            * Tip: create a new, separate directory for each feed: some feeds (such as about the project you are working on) are more important to you than others.

        * [Google Reader](http://www.google.com/reader)

    * Subscribe to jira issue changes:

        * [JDOCBOOKSTYLE](https://issues.jboss.org/plugins/servlet/streams?key=JDOCBOOKSTYLE&os_authType=basic)

* Join us on IRC: irc.freenote.net #jboss-docs

Releasing
=========

First check it builds:

    $ mvn clean install

If everything is perfect:

* Define the version and create the tag:

        $ mvn release:prepare

    * Note: Always use at least 3 numbers in the version: '2.0.0' is fine, `2.0` is not fine.

* Deploy the artifacts:

        $ mvn release:perform

* Go to [nexus](https://repository.jboss.org/nexus), menu item *Staging repositories*, find your staging repository.

    * Button *close*

    * Button *release*

* Go to [jira](https://issues.jboss.org/browse/JDOCBOOKSTYLE):

    * Open menu item *Administration*, link *Manage versions*, release the version.

    * Create new versions if needed.

* Warning: The slightest change after you created the tag requires the use of the next version number!

    * **NEVER TAG OR DEPLOY A VERSION THAT ALREADY EXISTS AS A TAG OR A DEPLOY!!!**

        * Except deploying `SNAPSHOT` versions.

        * Git tags are cached on developer machines forever and are never refreshed.

        * Maven non-snapshot versions are cached on developer machines and proxies forever and are never refreshed.

    * So even if the release is broken, do not reuse the same version number! Create a hotfix version.

FAQ
===


