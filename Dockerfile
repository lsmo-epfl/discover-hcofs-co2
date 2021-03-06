FROM python:3.7

# Install nodejs for jsmol-bokeh-extension
RUN apt-get update && apt-get install -y --no-install-recommends \
  nodejs \
  graphviz \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean all

## Install jsmol
WORKDIR /app
#
#RUN wget https://sourceforge.net/projects/jmol/files/Jmol/Version%2014.29/Jmol%2014.29.22/Jmol-14.29.22-binary.zip/download --output-document jmol.zip
#RUN unzip jmol.zip && cd jmol-14.29.22 && unzip jsmol.zip

# get latest aiida version
# Remove this once v1.1.0 is released
RUN git clone --depth 100 https://github.com/aiidateam/aiida-core.git
RUN cd aiida-core && git checkout 6ce6cd48907bd3976e50e260e8b609d74c9cf692 && cd ..
RUN pip install -e aiida-core

# Install discover section
ENV AIIDA_PATH /app
ENV PYTHONPATH /app
WORKDIR /app/discover-cofs

COPY figure ./figure
#COPY detail ./detail
#COPY select-figure ./select-figure
#RUN ln -s /app/jmol-14.29.22/jsmol ./detail/static/jsmol
COPY setup.py ./
RUN pip install -e .
COPY .docker/serve-app.sh /opt/
COPY .docker/config.json $AIIDA_PATH/.aiida/

# start bokeh server
EXPOSE 5006
CMD ["/opt/serve-app.sh"]

#EOF
