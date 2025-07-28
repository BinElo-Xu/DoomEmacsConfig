;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!
;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; 字体配置: 黄金搭档方案

;; --- 1: 使用官方变量设置英文字体 ---

;; 设置主要等宽字体 (用于代码和大部分UI)
(setq doom-font (font-spec :family "Fira Code" :size 16))

;; 设置可变宽度字体 (用于 Org 正文、注释等，提升阅读体验)
(setq doom-variable-pitch-font (font-spec :family "Source Serif 4" :size 16))


;; --- 2: 使用 set-fontset-font 单独配置中文字体 ---

;; `after!` 确保在 Doom 的字体设置加载完毕后再执行我们的配置
(after! 'doom-font
  ;; t 表示修改所有字体集
  ;; 'han 表示中文字符集
  ;; "思源宋体 CN" 是推荐字体，效果远好于系统默认的 "宋体"
  ;; 请确保你已经安装了 "Source Han Serif CN" 或 "思源宋体 CN"
  (set-fontset-font t 'han (font-spec :family "Source Han Serif CN")))


;; --- 3: 让中文在不同场景下使用不同字体 ---
(after! 'doom-font
  ;; 1. 默认 (等宽) 场景下的中文字体使用黑体 (更清晰)
  (set-fontset-font t 'han (font-spec :family "Source Han Sans CN") nil 'prepend)

  ;; 2. 在可变宽度 (variable-pitch) 场景下，中文字体使用宋体 (更适合阅读)
  (set-fontset-font t 'han (font-spec :family "Source Han Serif CN") (frame-parameter nil 'font) 'append))

;;==================================================
;;Org-mode PAPR Method Configuration For Doom Emacs|
;;==================================================

;; --- 1. 基础 Org-mode 和 PARA 结构设置 ---
;; 定义你的 org 根目录，方便以后引用
(setq org-directory "D:/WorkSpace/Org/")

;; 因为我们用了 org-roam, org-roam-directory 会自动被设为 org-directory
;; Doom 的 +roam2 模块已经帮我们设置好了 org-roam-directory
;; 我们只需要确保它的值是我们想要的
(after! org-roam
  (setq org-roam-directory (file-truename org-directory)))

;; 告诉 Org Agenda 去哪些地方寻找你的 org 文件
;; 推荐的、更完整的配置
(setq org-agenda-files (list (concat org-directory "inbox.org")
                             (concat org-directory "10_projects")
                             (concat org-directory "20_areas")
                             (concat org-directory "30_resources")
                             (concat org-directory "40_archives")))

;; --- 2. 配置 Org Capture 以匹配 PARA 流程 ---
;; Doom 的快捷键是 SPC o c 或者 C-c c
(after! org
  (setq org-capture-templates
        `(("t" "Todo [inbox]" entry
           (file+headline ,(concat org-directory "inbox.org") "Tasks")
           "* TODO %?\n  %i\n  %a")
          ("n" "Note [inbox]" entry
           (file+headline ,(concat org-directory "inbox.org") "Notes")
           "* %?\n  %i\n  %a"))))

;; --- 3. 配置 Org Refile 来整理笔记 ---
(after! org
  ;; 设置 refile 的目标为所有 agenda 文件中的标题 (最大3级)
  (setq org-refile-targets '((org-agenda-files :maxlevel . 3)))
  ;; 在 refile 时使用更简洁的路径
  (setq org-refile-use-outline-path nil)
  ;; 允许创建新的父标题进行 refile
  (setq org-refile-allow-creating-parent-nodes 'confirm))

;; --- 4. 配置 Org Roam Dailies ---
;; Doom 的 +roam2 模块已经配置好了大部分
;; 我们只需要指定 dailies 的目录
(after! org-roam
  (setq org-roam-dailies-directory "journal/")) ; 相对于 org-roam-directory

;; --- 5. 自定义快捷键 ---
;; Doom 使用 "Leader" 键 (通常是 SPC)
;; 我们可以为 PARA 工作流创建一组方便的快捷键，比如以 SPC n p 开头 (note-para)
(map! :leader
      :prefix ("n p" . "para")
      "i" #'(lambda () (interactive) (find-file (concat org-directory "inbox.org")))
      "p" #'(lambda () (interactive) (dired (concat org-directory "10_projects/")))
      "a" #'(lambda () (interactive) (dired (concat org-directory "20_areas/")))
      "r" #'(lambda () (interactive) (dired (concat org-directory "30_resources/")))
      "A" #'(lambda () (interactive) (dired (concat org-directory "40_archives/"))))

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;;(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
