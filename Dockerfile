FROM continuumio/miniconda3:latest
RUN apt-get update && apt-get install -y git jq curl \
    && rm -rf /var/lib/apt/lists/*

COPY environment.yml /tmp/environment.yml

RUN conda env create -f /tmp/environment.yml \
    && conda run -n fnds python -m ipykernel install --sys-prefix \
         --name=fnds --display-name="Python (fnds)" \
    && QUAP_PATH=$(conda run -n fnds python -m pip show pymc3-quap \
         | grep Location | awk '{print $2}') \
    && conda run -n fnds sed -i 's/pymc3/pymc/g' "${QUAP_PATH}/quap/quap.py" \
    && conda clean -afy \
    && rm /tmp/environment.yml
