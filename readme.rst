
Build on Linux
==============

Best to build in a Python Virtual Environment

To check/create the venv and use it in the build::

 make -f venv.mk html

The venv.mk will create/update a virt env (if not availablie ) in current dir/venv AND run the html build in it.

If you want for some reason start from scratch::

 make -f venv.mk cleanall

You can also use that virtual environment later doing::

 source/bin/activate

to activate the venv and then run the build from within that venv::

 make html

Alternative
...........

You can also use your own virtual env by creating it using it first::

 # you NEED python >3.6. Depending on distro either use `python3` or `python`
 # common name is 'venv' but call it whatever you like

 python3 -m venv venv  # using the venv module, create a venv named 'venv'

Then activate the venv and install the requirements via the REQUIRMENTS.txt::

 source ./venv/bin/activate
 pip install -r REQUIREMENTS.txt

and run the build from within that venv::

 make html

Want to build your own language? Note that you will use the translations from the
po files from git! For example for 'nl' do::

 make LANG=nl html

Build on Windows
================

You need to install git (https://git-scm.com/download/win) and Python3 (https://www.python.org/downloads/windows/)

Install both in default places and with default options.

Clone the repository, and go into that directory.

Then create a virtual environment called 'venv' in that directory, and activate it (Google for Python Virtual Env on Windows for more details):

::

 pip install -r REQUIREMENTS.txt venv
 # in dos box:
 venv\Scripts\activate.bat
 make.bat

Want to build your own language? Note that you will use the translations from the
po files from git! For example 'nl' do::

 set SPHINXOPTS=-D language=nl
 make.bat



Translating
===========

http://www.sphinx-doc.org/en/master/usage/advanced/intl.html

https://pypi.org/project/sphinx-intl/

https://docs.transifex.com/integrations/transifex-github-integration

We created a script to create the transifex yaml files for github-transifex integrations::

 .\scripts\create_transifex_yaml.sh

To create the .tx/config to push/pull using tx client do::

 sphinx-intl create-txconfig
 sphinx-intl update-txconfig-resources --transifex-project-name qgisdoc

To update the english po files (which are being used as SOURCE files in transifex)::

 # FIRST create the pot files in build/gettext (po file be based on those pot files)
 make gettext
 # then update the english po files only:
 sphinx-intl update -p build/gettext -l en

To update all po files (which we do not use if we do github-transifex integration!!!)::

 export SPHINXINTL_LANGUAGE=de,nl, ...
 # is the same same as
 sphinx-intl <command> --language=de --language=nl ...


Testing Python snippets
=======================

To test Python code snippets, you need a *QGIS* installation. There are many options:

* You can use your system *QGIS* installation with *Sphinx* from Python virtual environment:

  .. code-block:: bash

   make -f venv.mk doctest

* You can use a manually built installation of *QGIS*, to do so, you need to
  create a custom ``Makefile`` extension on top of the ``venv.mk`` file,
  for example a ``user.mk`` file with the following content:

  .. code-block:: mk

   # Root installation folder
   QGIS_PREFIX_PATH = /home/user/apps/qgis-master

   # Or build output folder
   QGIS_PREFIX_PATH = /home/user/dev/QGIS-build-master/output

   include venv.mk

  Then use it to run target ``doctest``:

  .. code-block:: bash

   make -f user.mk doctest

* Or you can run target ``doctest`` inside the official *QGIS* docker image:

  .. code-block:: bash

   make -f docker.mk doctest

Note that only code blocks with directive ``testcode`` are tested and
it is possible to run tests setup code which does not appear in documentation
with directive ``testsetup``, for example:

.. code-block:: py

 .. testsetup::

     from qgis.core import QgsCoordinateReferenceSystem

 .. testcode::

     # PostGIS SRID 4326 is allocated for WGS84
     crs = QgsCoordinateReferenceSystem(4326, QgsCoordinateReferenceSystem.PostgisCrsId)
     assert crs.isValid()

For more information see *Sphinx* doctest extension documentation:
https://www.sphinx-doc.org/en/master/usage/extensions/doctest.html



