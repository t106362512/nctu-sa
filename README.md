# NCTU HW - FreeBSD SA

## 📝 作業進度

- [x] HW2 Shell script
- [x] HW3 File server
- [x] HW4 Web server
- [x] HW5 NFS server

## 📝 作業補充說明

- HW2 Shell script

  - 作業需求可參考 [2020-SA-One liner script & System Info](https://nasa.cs.nctu.edu.tw/sa/2020/slides/HW2.pdf)
  - 建立與實作可以參考 [init.yml](nctu-hw/plays/init.yml), 以推送送腳本和發送命令給每台 server
  - 腳本檔案都在 [nctu-hw/plays/files/hw/2](nctu-hw/plays/files/hw/2)

- HW3 File server

  - 作業需求可參考 [2020-SA-File server & Backup](https://nasa.cs.nctu.edu.tw/sa/2020/slides/HW3.pdf)
  - 手動實作與詳細記錄可參考 [HW3-File-server-Backup](https://wax-note-1ec.notion.site/HW3-File-server-Backup-120d610a3fbd4f9f81e18d232847d55e)
  - 建立與實作可以參考 [ftp-server.yml](nctu-hw/plays/ftp-server.yml) 以建立 ftp server
  - pure-ftpd 的設定擋與腳本都在 [nctu-hw/plays/files/ftp](nctu-hw/plays/files/ftp)
  - zfs 備份 cli 則是在 [nctu-hw/plays/files/hw/3/zfsbak.sh](nctu-hw/plays/files/hw/3/zfsbak.sh), 在部署主機上直接使用指令 `zfsbak` 即可

- HW4 Web server

  - 作業需求可參考 [2020-SA-Web Services](https://nasa.cs.nctu.edu.tw/sa/2020/slides/HW4.pdf)
  - 手動實作與詳細記錄可參考 [HW4-Web Services](https://wax-note-1ec.notion.site/HW4-Web-Services-16a0c20e51b84bdda6636b9a5c5523fe)
  - 使用 nginx 與 php-fpm 來搞 web server
  - Web socket server 目前得在部署主機上使用指令 `bash /var/www/wsdemo/startws.sh` 以開啟 ws server.(通常都使用 socket.io 之類的玩意, 所以就懶得處理)
  - Wordprees 僅做好引導自動化, 請在相關服務建立好後，再進到 Wordprees 去設定資料庫
  - 可以參考 [web-server.yml](nctu-hw/plays/web-server.yml) 以建立 web server
  - Basic App Router 之作業檔案在 [nctu-hw/plays/files/hw/4/index.php](nctu-hw/plays/files/hw/4/index.php)
  - WebSocket 之作業檔案在 [nctu-hw/plays/files/hw/4/index.html](nctu-hw/plays/files/hw/4/index.php)

- HW5 NFS server

  - 作業需求可參考 [2020-SA-NIS & NFS](https://nasa.cs.nctu.edu.tw/sa/2020/slides/HW5v2.pdf)
  - 手動實作與詳細記錄可參考 [HW5-NFS](https://wax-note-1ec.notion.site/HW5-NFS-e153515e90f74f628ca6193a67544461)
  - 可以參考 [nfs-server.yml](nctu-hw/plays/nfs-server.yml) 以建立 nfs server
  - 可以參考 [nfs-client.yml](nctu-hw/plays/nfs-client.yml) 以讓 nfs client 掛載 nfs (使用 autofs)
  - 目前沒有做 NIS, 因為後續的 NA 有 LDAP 能做出 NIS 的效果
  - 目前有改 /data/web_hosting 與 /data/home 以符合作業需求
  - 目前需求 5-2 得要修改為 https://{ID}.nctu.cs/{pure-ftpd_user}/uploadscript.log

- 共通說明

  - 此自動化僅適用於 FreeBSD

  - 配合 vagrant 使用測試用虛擬主機

    ```bash
    cd nctu-hw/provisioner
    export VAGRANT_EXPERIMENTAL="disks" # 開啟建立硬碟功能, 否則 vagrant 無法幫你建立額外的硬碟
    vagrant up                          # 建立所有 Vagrantfile 的 vm
    vagrant reload                      # 重新載入 vagrant 設定並重開機
    vagrant ssh nfs                     # ssh 到 nfs vm
    vagrant halt                        # 關閉所有 Vagrantfile 的 vm
    vagrant destroy -f                  # 刪除所有 Vagrantfile 的 vm
    ```

  - 我把 Ansible 工作目錄設計在 [plays](nctu-hw/plays) 上, 因此請先到該目錄在下達指令

    ```bash
    cd nctu-hw/plays
    ansible-playbook init.yml  nfs-server.yml nfs-client.yml ftp-server.yml web-server.yml
    ```

  - 所有的 server 都要使用 [init.yml](nctu-hw/plays/init.yml), 為每台 server 安裝 python 以滿足成為 Ansible 被控端之資格
  - 關於被控端的 server list, 可以參考 [inventory.ini](nctu-hw/inventory.ini), 你可以修改它以符合需求
  - 所有的 ansible-playbook 的變數文件都在 [group_vars](nctu-hw/group_vars), 而 secret 則是在 [vault.yml](nctu-hw/group_vars/nfs/vault.yml) 中
  - 所有 secret 的加密密碼都在 [vpass](nctu-hw/vpass),而執行 ansible-playbook 時也會看 [ansible.cfg](nctu-hw/plays/ansible.cfg) 之密碼設定位置去解密並讀取變數。另外，可以下達指令去做加解密 secret 以編輯 secret

    ```bash
    cd nctu-hw/plays
    ansible-vault encrypt $(ls -d ../**/*/vault.yml)
    ansible-vault decrypt $(ls -d ../**/*/vault.yml)
    ```

  - 上述的作業幾乎都有做手動部署的記錄，可以參考[這裡](https://www.notion.so/065991228686494a988b5c59c44008ea?v=a7628d2ba8f9406e83bb4cfa9c477d11)

## 🧐 Problem Statement

It is useful to design and follow a specific format when writing a problem statement. While there are several options
for doing this, the following is a simple and straightforward template often used in Business Analysis to maintain
focus on defining the problem.

- IDEAL: This section is used to describe the desired or “to be” state of the process or product. At large, this section
  should illustrate what the expected environment would look like once the solution is implemented.
- REALITY: This section is used to describe the current or “as is” state of the process or product.
- CONSEQUENCES: This section is used to describe the impacts on the business if the problem is not fixed or improved upon.
  This includes costs associated with loss of money, time, productivity, competitive advantage, and so forth.

Following this format will result in a workable document that can be used to understand the problem and elicit
requirements that will lead to a winning solution.

## 💡 Idea / Solution

This section is used to describe potential solutions.

Once the ideal, reality, and consequences sections have been
completed, and understood, it becomes easier to provide a solution for solving the problem.

## ⛓️ Dependencies / Limitations

- What are the dependencies of your project?
- Describe each limitation in detailed but concise terms
- Explain why each limitation exists
- Provide the reasons why each limitation could not be overcome using the method(s) chosen to acquire.
- Assess the impact of each limitation in relation to the overall findings and conclusions of your project, and if
  appropriate, describe how these limitations could point to the need for further research.

## 🚀 Future Scope

Write about what you could not develop during the course of the Hackathon; and about what your project can achieve
in the future.

## 🏁 Getting Started

These instructions will get you a copy of the project up and running on your local machine for development
and testing purposes. See [deployment](#deployment) for notes on how to deploy the project on a live system.

### Prerequisites

請參考[說明文件](nctu-hw/README.MD)並安裝 [Ansible](https://www.ansible.com) 和 [Vagrant](https://www.vagrantup.com) 以建立開發環境與自動化佈署。

目前 Ansible 不支援 Windows 作為控制端，而我預設使用的是 Vagrant providers 是 [VirtualBox](https://www.virtualbox.org)(排除效能等，問題相對較少)。

要使用該自動化腳本必須滿足以下條件。

1. [據官方說明](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#control-node-requirements) Host OS 不能是 Windows，但還是可以硬用 WSL 或在已支援的 Linux 發行版 Dcoker Container or VM 上執行 Ansible.

1. 安裝 [Ansible](nctu-hw/README.MD#How_to_use)

1. 安裝 [Vagrant](https://learn.hashicorp.com/tutorials/vagrant/getting-started-index)，該項目是用來建立 VM 以快速建立測試環境。

1. 安裝 [VirtualBox](https://www.virtualbox.org)

### Installing

1. 安裝 Ansible

```bash
python3 -m pip install pipx
pipx install ansible
```

1. 安裝 Ansible playbook 相依插件

```bash
pipx inject ansible $(cat nctu-hw/requirements.txt|tr '\n' ' ')
```

1. 安裝 Ansible playbook roles(基本上不用再裝, 有使用的 roles 我已經包在專案內並在 ansible.cfg 設定使用位置了)

```bash
ansible-galaxy install -r nctu-hw/roles/requirements.yml -p nctu-hw/roles/external
```

1. 安裝 Vagrant 相依插件

```bash
vagrant plugin install vagrant-hosts
```

## 🎈 Usage

Add notes about how to use the system.

## ✍️ Authors

[ChihChia_Wang](mailto:ChihChia4Wang@gmail.com)

## 🎉 Acknowledgments

- Hat tip to anyone whose code was used
- Inspiration
- References
