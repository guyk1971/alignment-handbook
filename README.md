<p align="center">
  <img src="https://raw.githubusercontent.com/huggingface/alignment-handbook/main/assets/handbook.png">
</p>

<p align="center">
    🤗 <a href="https://huggingface.co/collections/alignment-handbook/handbook-v01-models-and-datasets-654e424d22e6880da5ebc015" target="_blank">Models & Datasets</a> | 📃 <a href="https://arxiv.org/abs/2310.16944" target="_blank">Technical Report</a>
</p>

# The Alignment Handbook - gkoren

Robust recipes to align language models with human and AI preferences.

## What is this?

Just one year ago, chatbots were out of fashion and most people hadn't heard about techniques like Reinforcement Learning from Human Feedback (RLHF) to align language models with human preferences. Then, OpenAI broke the internet with ChatGPT and Meta followed suit by releasing the Llama series of language models which enabled the ML community to build their very own capable chatbots. This has led to a rich ecosystem of datasets and models that have mostly focused on teaching language models to follow instructions through supervised fine-tuning (SFT).

However, we know from the [InstructGPT](https://huggingface.co/papers/2203.02155) and [Llama2](https://huggingface.co/papers/2307.09288) papers that significant gains in helpfulness and safety can be had by augmenting SFT with human (or AI) preferences. At the same time, aligning language models to a set of preferences is a fairly novel idea and there are few public resources available on how to train these models, what data to collect, and what metrics to measure for best downstream performance.

The Alignment Handbook aims to fill that gap by providing the community with a series of robust training recipes that span the whole pipeline.

## News 🗞️
* **February 1, 2024:** We release a recipe to align open LLMs with Constitutional AI 📜! See the [recipe](https://github.com/huggingface/alignment-handbook/tree/main/recipes/constitutional-ai) and the [blog post](https://huggingface.co/blog/constitutional_ai) for details. 
* **January 18, 2024:** We release a suite of evaluations of DPO vs KTO vs IPO, see the [recipe](recipes/pref_align_scan/README.md) and the [blog post](https://huggingface.co/blog/pref-tuning) for details.
* **November 10, 2023:** We release all the training code to replicate Zephyr-7b-β 🪁! We also release [No Robots](https://huggingface.co/datasets/HuggingFaceH4/no_robots), a brand new dataset of 10,000 instructions and demonstrations written entirely by skilled human annotators.

## Links 🔗

* [Zephyr 7B models, datasets, and demos](https://huggingface.co/collections/HuggingFaceH4/zephyr-7b-6538c6d6d5ddd1cbb1744a66)

## How to navigate this project 🧭

This project is simple by design and mostly consists of:

* [`scripts`](./scripts/) to train and evaluate chat models. Each script supports distributed training of the full model weights with DeepSpeed ZeRO-3, or LoRA/QLoRA for parameter-efficient fine-tuning.
* [`recipes`](./recipes/) to reproduce models like Zephyr 7B. Each recipe takes the form of a YAML file which contains all the parameters associated with a single training run.

We are also working on a series of guides to explain how methods like direct preference optimization (DPO) work, along with lessons learned from gathering human preferences in practice. To get started, we recommend the following:

1. Follow the [installation instructions](#installation-instructions) to set up your environment etc.
2. Replicate Zephyr-7b-β by following the [recipe instructions](./recipes/zephyr-7b-beta/README.md).

If you would like to train chat models on your own datasets, we recommend following the dataset formatting instructions [here](./scripts/README.md#fine-tuning-on-your-datasets).


## Contents

The initial release of the handbook will focus on the following techniques:

* **Supervised fine-tuning:** teach language models to follow instructions and tips on how to collect and curate your own training dataset.
* **Reward modeling:** teach language models to distinguish model responses according to human or AI preferences.
* **Rejection sampling:** a simple, but powerful technique to boost the performance of your SFT model.
* **Direct preference optimisation (DPO):** a powerful and promising alternative to PPO.

## Installation instructions
there are 2 options to install the project:  
1. Using conda environment
2. using docker image  

### 1. Using conda environment
To run the code in this project, first, create a Python virtual environment using e.g. Conda:

```shell
conda create -n handbook python=3.10 && conda activate handbook
```
Next, install PyTorch `v2.1.2` - the precise version is important for reproducibility! Since this is hardware-dependent, we
direct you to the [PyTorch Installation Page](https://pytorch.org/get-started/locally/).

You can now install the remaining package dependencies as follows:

```shell
git clone https://github.com/huggingface/alignment-handbook.git
cd ./alignment-handbook/
python -m pip install .
python -m pip install flash-attn==2.3.6 --no-build-isolation
```

### 2. Using docker image
create a docker image using the following command:
```shell
./env_scripts/docker_build_run_lws.sh
```
this will build the required dependencies in a docker image and will run it.  
now perform the required installations from within the container 

```shell
python -m pip install .
python -m pip install flash-attn --no-build-isolation
```

### rest of instructions for both virtual env and container scenarios

> **Note**
> If your machine has less than 96GB of RAM and many CPU cores, reduce the `MAX_JOBS` arguments, e.g. `MAX_JOBS=4 pip install flash-attn==2.3.6 --no-build-isolation`

Next, log into your Hugging Face account as follows:

```shell
huggingface-cli login
# or
~/.local/bin/huggingface-cli login # if the above fails on 'command not found'
```

Finally, install Git LFS so that you can push models to the Hugging Face Hub:

```shell
sudo apt-get install git-lfs
```

### Post installation for docker image scenario  
now its recommended that you'll **open vs code** and attach to the running container s.t. the vs-code will install itself inside the container. also, make sure to open some python files and any other add-ons you'd like to add to vs-code.

now you're ready to commit the changes back to the image:

- Temporaly exit the container (ctrl+P+Q) and commit to the image:
```
gkoren@430f346ccb18:~/scratch/code/github/guyk1971/safari$ <press ctrl+p+q>
gkoren@ipp1-2161:~/safari$ docker commit <container_id> <image_name>
gkoren@ipp1-2161:~/safari$ docker push <image_name>  # optional
gkoren@ipp1-2161:~/safari$ docker attach <container_id>
```
where:
- `<container_id>` in this case is `430f346ccb18`  
- `image_name`= `<docker_repository>/<repo_name>:<updated_image_tag>`  


write down the `image_name` and update it in the `docker_run_lws.sh` and `docker_run_lws_multi.sh`.
in this case, I set the image name  `alignhb_${MY_UNAME}:dev`

next time you want to run the container, just run the `docker_run_lws.sh` script (or `docker_run_lws_multi.sh` for multi containers running in parallel) and it will run the container with the updated image.


## Using the handbook
You can now check out the `scripts` and `recipes` directories for instructions on how to train some models 🪁!

## Project structure

```
├── LICENSE
├── Makefile                    <- Makefile with commands like `make style`
├── README.md                   <- The top-level README for developers using this project
├── chapters                    <- Educational content to render on hf.co/learn
├── env_scripts                 <- scripts to create the environment (docker)
├── recipes                     <- Recipe configs, accelerate configs, slurm scripts
├── sandbox                     <- my own experiments with the tools in this repo
├── scripts                     <- Scripts to train and evaluate chat models
├── setup.cfg                   <- Installation config (mostly used for configuring code quality & tests)
├── setup.py                    <- Makes project pip installable (pip install -e .) so `alignment` can be imported
├── src                         <- Source code for use in this project
└── tests                       <- Unit tests
```

## Citation

If you find the content of this repo useful in your work, please cite it as follows:

```bibtex
@misc{alignment_handbook2023,
  author = {Lewis Tunstall and Edward Beeching and Nathan Lambert and Nazneen Rajani and Shengyi Huang and Kashif Rasul and Alexander M. Rush and Thomas Wolf},
  title = {The Alignment Handbook},
  year = {2023},
  publisher = {GitHub},
  journal = {GitHub repository},
  howpublished = {\url{https://github.com/huggingface/alignment-handbook}}
}
```
