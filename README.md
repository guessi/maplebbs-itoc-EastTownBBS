# MapleBBS-itoc-EastTownBBS

[![docker-build](https://github.com/guessi/easttownbbs/actions/workflows/docker-build.yml/badge.svg)](https://github.com/guessi/easttownbbs/actions/workflows/docker-build.yml)

**EastTown** 為 [國立東華大學](https://www.ndhu.edu.tw/) － [東方小城](http://bbs.ndhu.edu.tw) 之英文直譯，為 [MapleBBS-3.10-itoc](http://processor.tfcis.org/~itoc) 專案的衍生作品。

![](http://bbs.ndhu.edu.tw/link?frontpage.png)

更多 MapleBBS 歷史資訊請參考：https://bbslist.github.io/

## 專案背景

本專案由 [guessi](https://github.com/guessi) 維護，曾擔任國立東華大學東方小城、電機系站、資工系站的系統站長，同時也是 MapleBBS-itoc 分支的貢獻者。

### 發展時程

- **2006-2012**：承接校站維運作業
- **2012/Q3**：畢業離校，將維護版本開源至 GitHub
- **2015/Q3**：增加 CentOS, Ubuntu, FreeBSD (32-bit) 支援
- **2025/Q3**：升級至 Debian 13 (64-bit)，新增容器支援
- **2026/Q1**：前端 jQuery 升級至 3.7.1，並進行 JS 程式碼清理與優化
- **2026/Q3**：容器建置優化（image size 大幅縮減至 159.4MB）並進行容器現代化改造

## 功能限制

### 網頁版登入功能

考量維護人力不足，網頁版僅提供唯讀模式，不開放登入功能。


## 快速開始

### 建置容器

```bash
docker build -t easttownbbs .
```

> 建置採用 multi-stage，快取有效時重建很快；若需完整重建可加上 `--no-cache`。

### 啟動服務

> 特別留意：
> 以下指令僅是 Proof-of-concept 展示，因此沒有額外掛載目錄，因此容器終止後資料將會消失。
> 若需要資料留存，請務必記得修改相關配置，確保資料可以被留存。

```bash
docker run --rm -p 2323:23 -it easttownbbs
```

### 連線方式

**Telnet 連線**（使用 PCMan/KKMan/Welly 等工具）：
```bash
telnet 127.0.0.1 2323
```

**網頁瀏覽**（唯讀模式）：

容器預設僅啟動 Telnet 服務（`bbsd`），網頁服務（`bhttpd`）預設不啟動。
若需啟用，請取消 `docker-entrypoint.sh` 中 `bhttpd` 的註解並重新建置，
啟動容器時再加上 `-p 8080:80` 埠號對應：

```
http://127.0.0.1:8080
```

### 例行排程

容器內建 cron，排程定義於 `crontab.bbs`（佈署至 `/etc/cron.d/bbs`），
預設僅啟用 `account`（人次統計）與 `camera`（動態看板）兩項例行工作。
其餘項目（轉信、排行榜、文章 expire、備份等）以註解保留，
若需啟用請一併確認 `docker-entrypoint.sh` 中對應元件已啟動。
特別留意：容器時區為 UTC，每日排程的時間點請自行換算。

## 開發與維運困境

雖然底層已從 FreeBSD (32-bit) 逐步更新至現在的 Debian 13 (64-bit) 不過程式碼年久失修。即使可以運行，仍然可能存在瑕疵需要修正。

### 主要挑戰

- **32-bit 限制**：早年程式碼僅支援 32-bit 作業系統，缺乏 64-bit 支援彈性
- **32-bit 支援**：以目前選用的 Debian 13 為例，也可以在 [Release Notes](https://www.debian.org/releases/stable/release-notes/issues.en.html#reduced-support-for-i386) 當中看到相關宣告，顯示 32-bit to 64-bit 之系統轉換勢在必行
- **編譯工具支援**：主流作業系統陸續停止 32-bit 支援，編譯工具也開始停止支援
- **Year 2038 Problem**：https://en.wikipedia.org/wiki/Year_2038_problem
- **編碼問題**：所有文件均使用 [大五碼 (Big-5)](https://zh.wikipedia.org/zh-tw/%E5%A4%A7%E4%BA%94%E7%A2%BC) 編碼儲存，而非主流的 [UTF-8](https://zh.wikipedia.org/zh-tw/UTF-8)

在缺乏人力維護的困境下，非常需要人員加入維護。

### 更多關於 [guessi](https://github.com/guessi) 開發的功能可以在下面連結找到（僅列出部分）

<details><!-- markdownlint-disable-line -->
<summary>Click to expand!</summary><!-- markdownlint-disable-line -->

* https://github.com/xeonchen/maplebbs-itoc/blob/master/gem/3/A11V6KT3
* https://github.com/xeonchen/maplebbs-itoc/blob/master/gem/3/A120E6G3
* https://github.com/xeonchen/maplebbs-itoc/blob/master/gem/4/A123IK04
* https://github.com/xeonchen/maplebbs-itoc/blob/master/gem/8/A0VON2J8
* https://github.com/xeonchen/maplebbs-itoc/blob/master/gem/9/A12F0BS9
* https://github.com/xeonchen/maplebbs-itoc/blob/master/gem/A/A120IA9A
* https://github.com/xeonchen/maplebbs-itoc/blob/master/gem/A/A1248IJA
* https://github.com/xeonchen/maplebbs-itoc/blob/master/gem/A/A12ETKJA
* https://github.com/xeonchen/maplebbs-itoc/blob/master/gem/B/A122P16B
* https://github.com/xeonchen/maplebbs-itoc/blob/master/gem/C/A12B3GSC
* https://github.com/xeonchen/maplebbs-itoc/blob/master/gem/E/A12VB0ME
* https://github.com/xeonchen/maplebbs-itoc/blob/master/gem/F/A12L28FF
* https://github.com/xeonchen/maplebbs-itoc/blob/master/gem/F/A12L63JF
* https://github.com/xeonchen/maplebbs-itoc/blob/master/gem/G/A1248JCG
* https://github.com/xeonchen/maplebbs-itoc/blob/master/gem/G/A127SCJG
* https://github.com/xeonchen/maplebbs-itoc/blob/master/gem/G/A128D90G
* https://github.com/xeonchen/maplebbs-itoc/blob/master/gem/H/A117BP8H
* https://github.com/xeonchen/maplebbs-itoc/blob/master/gem/H/A122CSUH
* https://github.com/xeonchen/maplebbs-itoc/blob/master/gem/H/A127PTRH
* https://github.com/xeonchen/maplebbs-itoc/blob/master/gem/H/A12BQ0KH
* https://github.com/xeonchen/maplebbs-itoc/blob/master/gem/I/A122Q1OI
* https://github.com/xeonchen/maplebbs-itoc/blob/master/gem/J/A126EGAJ
* https://github.com/xeonchen/maplebbs-itoc/blob/master/gem/J/A12QCLCJ
* https://github.com/xeonchen/maplebbs-itoc/blob/master/gem/O/A124N49O
* https://github.com/xeonchen/maplebbs-itoc/blob/master/gem/P/A128SEQP
* https://github.com/xeonchen/maplebbs-itoc/blob/master/gem/Q/A12OD6HQ
* https://github.com/xeonchen/maplebbs-itoc/blob/master/gem/Q/A1346CBQ
* https://github.com/xeonchen/maplebbs-itoc/blob/master/gem/S/A12BRN1S
* https://github.com/xeonchen/maplebbs-itoc/blob/master/gem/S/A12VNAGS
* https://github.com/xeonchen/maplebbs-itoc/blob/master/gem/V/A126SJ4V
* https://github.com/xeonchen/maplebbs-itoc/blob/master/gem/V/A12ETLUV
* https://github.com/xeonchen/maplebbs-itoc/blob/master/gem/V/A12PQ08V

</details>
