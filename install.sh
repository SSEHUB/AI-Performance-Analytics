#!/bin/bash
TITLE="\033[31m"
NORMAL="\033[0m"
BASE_URL="https://raw.githubusercontent.com/SSEHUB/AI-Performance-Analytics/refs/heads/main/"

downloadScript() {
    curl -fsSL "${BASE_URL}/$1" -o $1
    sudo chmod +x $1
}

echo -e "${TITLE}Installing Required Packages${NORMAL}"
sudo apt -y install s-tui btop dmidecode lm-sensors tmux
# sudo sensors-detect --auto

echo -e "${TITLE}Downloading Scripts${NORMAL}"
downloadScript cpu_monitor.sh
downloadScript gpu_monitor.sh
downloadScript ram_monitor.sh
downloadScript computeAvg.sh
downloadScript perftest.sh
downloadScript dashboard.tmux
downloadScript stresstext.tmux
downloadScript modded-nogpt.run.sh

echo -e "${TITLE}Downloading and Preparing Benchmark${NORMAL}"
git clone https://github.com/KellerJordan/modded-nanogpt.git && cd modded-nanogpt
git checkout f503c83129d2cfe4def56c81c7cbc876d1489fb2
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
pip install --pre torch==2.6.0.dev20241231+cu126 --index-url https://download.pytorch.org/whl/nightly/cu126 --upgrade # install torch 2.6.0
python3 data/cached_fineweb10B.py 8 # downloads only the first 0.8B training tokens to save time
rm -f run.sh
cd -
mv modded-nogpt.run.sh modded-nanogpt/run.sh
