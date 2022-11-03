. ./env.sh
NVME_STATUS=$(sudo file -s /dev/nvme0n1)

echo $NVME_STATUS

if [ "$NVME_STATUS" = "/dev/nvme0n1: data" ]; then
    echo "initiate nvme0n1 SSD setting now."
    if [ -d "$DATA_PATH" ]; then
        sudo rm -r $DATA_PATH
    fi
    sudo mkdir $DATA_PATH
    sudo mkfs -t xfs /dev/nvme0n1
    sudo mount /dev/nvme0n1 $DATA_PATH
    sudo chmod -R 777 $DATA_PATH
else
    echo "nvme0n1 SSD had been formatted before."
fi
