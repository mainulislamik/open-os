# Open OS (Kali Cyber Edition)

> **Universal Multi-Platform Cyber Security Workspace based on Kali Linux**  
> Run Android (.apk), Windows (.exe), and Linux apps seamlessly with built-in penetration testing and reverse engineering capabilities.

---

## 🌟 Overview (সংক্ষিপ্ত পরিচিতি)
**Open OS** হলো একটি কাস্টমাইজযোগ্য লিনাক্স আর্কিটেকচার যা **Kali Linux**-এর ওপর ভিত্তি করে তৈরি। এটি সাইবার সিকিউরিটি রিসার্চার এবং পেনিট্রেশন টেস্টারদের জন্য এমন একটি পরিবেশ তৈরি করে যেখানে:
1. **Android Apps (.apk):** সরাসরি নেটিভ কার্নেল কনটেইনার স্পিডে চলে (Waydroid Subsystem)।
2. **Windows Binaries (.exe / .msi):** Wine-Staging এবং Proton লেয়ার দিয়ে রান করে।
3. **Cyber Security & Mobile Pentest:** Burp Suite / ZAP Proxy ইন্টারসেপশন, Frida-Server হুকিং, এবং JADX রিভার্স ইঞ্জিনিয়ারিং এক ক্লিকে ইন্টিগ্রেটেড।
4. **১০০% মডুলার:** আপনি যেকোনো সময় কনফিগারেশন বা প্যাকেজ লিস্ট পরিবর্তন করে নিজের মতো কাস্টমাইজ করতে পারবেন।

---

## 📁 Project Structure (প্রজেক্ট স্ট্রাকচার)

```text
/home/imon/open-os/
├── config/
│   ├── open-os.conf                # মূল কনফিগারেশন ফাইল (ফিচার অন/অফ করার টগল)
│   ├── packages.kali.list          # কালির সাইবার সিকিউরিটি প্যাকেজ লিস্ট
│   ├── packages.compatibility.list # Waydroid, Wine, LXC প্যাকেজ লিস্ট
│   └── packages.desktop.list       # Desktop Environment & Wayland প্যাকেজ
├── core/
│   ├── bin/
│   │   ├── open-os                 # মাস্টার CLI টুল (run, status, doctor, proxy, frida)
│   │   ├── open-os-apk-installer   # .apk ফাইল হ্যান্ডলার ও রানার
│   │   ├── open-os-exe-launcher    # .exe/.msi ফাইল হ্যান্ডলার ও Wine রানার
│   │   └── open-os-pentest-bridge  # মোবাইল সিকিউরিটি ও প্রক্সি ব্রিজ
│   └── desktop-entries/            # ফাইল ম্যানেজার রাইট-ক্লিক ও ওপেন উইথ মেনু
├── iso-builder/
│   ├── Dockerfile                  # আইসোলেটেড ডকার বিল্ডার
│   ├── builder-entrypoint.sh       # Kali Live-Build স্ক্রিপ্ট
│   └── build-iso.sh                # ১-ক্লিকে বুটেবল ISO তৈরির স্ক্রিপ্ট
└── scripts/
    └── setup-on-existing-kali.sh   # যেকোনো সাধারণ Kali VM-কে Open OS-এ রূপান্তর করার স্ক্রিপ্ট
```

---

## 🛠️ How to Modify Anytime (যেকোনো সময় কীভাবে কাস্টমাইজ করবেন)

Open OS সম্পূর্ণ মডুলার। আপনি নিচের ফাইলগুলো পরিবর্তন করে ওএস-এর আচরণ পরিবর্তন করতে পারেন:

1. **ফিচার পরিবর্তন করতে:**  
   `config/open-os.conf` ফাইলটি খুলুন। এখানে আপনি `ENABLE_ANDROID_ENGINE=true/false`, প্রক্সি পোর্ট, ডেক্সটপ সেশন ইত্যাদি পরিবর্তন করতে পারবেন।
2. **নতুন সিকিউরিটি টুল যুক্ত বা বাদ দিতে:**  
   `config/packages.kali.list` ফাইলে গিয়ে প্যাকেজের নাম লিখে দিন।
3. **উইন্ডোজ বা অ্যান্ড্রয়েড রানটাইম পরিবর্তন করতে:**  
   `config/packages.compatibility.list` এ প্যাকেজ যুক্ত বা বাদ দিন।

---

## 🚀 How to Use / Test (কীভাবে ব্যবহার বা টেস্ট করবেন)

### পদ্ধতি ১: যেকোনো বিদ্যমান Kali Linux VM-এ ইনস্টল করা (সবচেয়ে দ্রুত)
আপনার যদি VirtualBox বা VMware-এ ইতিমধ্যে একটি সাধারণ Kali Linux ইনস্টল করা থাকে:
```bash
cd /home/imon/open-os
sudo bash scripts/setup-on-existing-kali.sh
```
এটি স্বয়ংক্রিয়ভাবে Waydroid, Wine, ডেস্কটপ ফাইল অ্যাসোসিয়েশন এবং ওপেন ওএস কোর বাইনারি ইনস্টল করে দেবে।

---

### পদ্ধতি ২: সম্পূর্ণ বুটেবল ISO তৈরি করা (Standalone Installation)
সম্পূর্ণ স্বাধীন একটি `.iso` ফাইল তৈরি করতে যা সরাসরি VirtualBox বা ফিজিক্যাল পিসিতে বুট করা যাবে:
```bash
cd /home/imon/open-os/iso-builder
./build-iso.sh
```
*বিল্ড সম্পন্ন হলে `iso-builder/output/open-os-kali.iso` ফাইলে আউটপুট পাওয়া যাবে।*

---

## 💻 CLI Commands (কমান্ড তালিকা)

```bash
# যেকোনো ফাইল চালাও (স্বয়ংক্রিয়ভাবে .apk বা .exe ডিটেক্ট করবে)
open-os run /path/to/app.apk
open-os run /path/to/tool.exe

# অ্যান্ড্রয়েড সাবসিস্টেম কন্ট্রোল
open-os android start
open-os android ui
open-os android shell

# মোবাইল পেনিট্রেশন টেস্টিং ও প্রক্সি
open-os proxy on 192.168.240.1 8080   # Burp Suite এ ট্রাফিক পাঠানো
open-os proxy off                     # প্রক্সি বন্ধ করা
open-os frida start                   # Frida সার্ভার চালু করা
open-os analyze target.apk            # JADX দিয়ে ডিকম্পাইল করা

# সিস্টেম হেলথ চেক
open-os status
open-os doctor
```

---

## 🔒 Security & Virtual Machine Recommendations
- **VirtualBox / VMware সেটিংস:**
  - **Processors:** অন্তত ২ বা ৪ কোর বরাদ্দ করুন।
  - **Nested Virtualization:** অবশ্যই **Enable VT-x/AMD-V** চালু রাখুন (Waydroid কন্টেইনার দ্রুত চলার জন্য এটি দরকার)।
  - **Display:** 3D Acceleration চালু রাখুন এবং Graphics Controller `VMSVGA` নির্বাচন করুন।
