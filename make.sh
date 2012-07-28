#!/bin/bash
# make.sh: simple wrapper script for pandoc to turn text into a static site.

regex_name='s/\(.*\)\..*/\1/' # remove file extension

# Compiles markdown into html and html partials
for file in * ; do
  name=`echo $file | sed $regex_name`
  datename=`echo $(head -3 $file | tail -1 | grep "%" | tr -d "% ")`$name

  case $file in *.md|*.txt)

    # Markdown -> html 
    pandoc --template=_wrapper.html $file \
      -V link:$name.html \
      -o $name.html;

    # Markdown meta info -> html partials
    pandoc --template=_post.html $file \
      -V link:$name.html\
      -V readtime:`expr $(wc -w < $file) / 250 + 1` \
      -o `echo /tmp/$datename`.htmlpartial
esac
done


# Partials -> Single html page
pandoc --template=_wrapper.html $(ls /tmp/*.htmlpartial | sort -r) \
  -o index.html


# Poor man's cleanup
rm /tmp/*.htmlpartial
