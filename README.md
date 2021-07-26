# NCTU HW

## 📝 作業進度

- [x] HW2 Shell script
- [] HW3 File server
- [] HW4 Web server
- [] HW5 NFS server

## 📝 作業補充說明

- HW2 Shell script

  - 可以參考 [init.yml](nctu-hw/plays/init.yml), 以推送送腳本和發送命令給每台 server
  - 全部做完, 腳本檔案都在 [nctu-hw/plays/files/hw/2](nctu-hw/plays/files/hw/2)

- HW3 File server

  - 目前僅剩 ZFS 系列尚未做完
  - 可以參考 [ftp-server.yml](nctu-hw/plays/ftp-server.yml) 以建立 ftp server
  - 其餘的設定擋與腳本都在 [nctu-hw/plays/files/ftp](nctu-hw/plays/files/ftp)

- HW4 Web server

  - 使用 nginx 與 php-fpm 來搞 web server
  - Web socket 還沒做
  - Wordprees 僅做好引導自動化, 進到 wp 再去設定資料庫
  - 可以參考 [web-server.yml](nctu-hw/plays/web-server.yml) 以建立 web server
  - 其餘檔案都在 [nctu-hw/plays/files/hw/4](nctu-hw/plays/files/hw/4)

- HW5 NFS server

  - 目前僅剩 /vol/web_hosting 與 /data/web_hosting 之內容不確定
  - 可以參考 [nfs-server.yml](nctu-hw/plays/nfs-server.yml) 以建立 nfs server
  - 可以參考 [nfs-client.yml](nctu-hw/plays/nfs-client.yml) 以讓 nfs client 掛載 nfs

- 共通說明

  - 配合 vagrant 使用測試用虛擬主機

    ```bash
    cd nctu-hw/provisioner
    vagrant up # 建立所有 Vagrantfile 的 vm
    vagrant ssh nfs # ssh 到 nfs vm
    vagrant halt # 關閉所有 Vagrantfile 的 vm
    vagrant destroy -f # 刪除所有 Vagrantfile 的 vm
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
