# 学术研究论文撰写与 Typst 模板规范 (Academic Research Paper Context & Typst Specification)

## 1. 通用撰写指南 (Instrucciones Generales)

1. **学术规范**：严格遵守 **APA (7ª edición)** 格式标准进行学术表述与内容组织。
2. **论文篇幅**：**论文正文部分（不包括封面、目录 and 参考文献）必须有最少 10 页且最多 15 页的篇幅**。单章生成时请确保内容高度充实、深入，以保障整篇论著达到页数底线。
3. **结构严谨性**：确保每个章节的子部分逻辑清晰，过渡自然，段落之间环环相扣。
4. **原创性与学术深度**：内容必须是原创的、经过深度研究的，严禁肤浅的概述，应当深入探讨核心概念与原理。
5. **学术语言风格**：使用严谨、客观的**学术西班牙语 (español académico)** 进行撰写，绝对避免口语化表达、人称代词的过度使用以及任何行业俚语。
6. **学术文献引用**：使用学术且可信度高的文献支持核心论点。
7. **章节标题限制**：**在生成的任何章节内容中，绝对禁止使用一级标题（即以 `=` 开头的标题）**。一级标题和分页逻辑完全由外部模板统一控制。请直接从二级标题（`==`）或具体的子段落开始输出。
8. **列表使用限制**：**严禁滥用无序列表（`-`）或有序列表（`+`）**。在严谨的学术论著中，过多的列表会破坏行文的连贯性，影响学术严谨度。仅在必不可少的并列关系或步骤陈述时方可适量使用。
9. **字数与格式约束**：
   - 引言（**Introducción**）和结论（**Conclusión**）的生成篇幅必须控制在 **400 个西班牙语单词以内 (máximo 400 palabras)**，且各自必须有足够的深度，且**仅能包含一个自然段**。
10. **学术禁用词与连接词（极其重要）**：
    为了保证学术论文的高级感和连贯性，**绝对禁止**使用以下低级或套路化的西文过渡/总结性词汇（及其对应的中文语义表达）：
    - **禁用词列表**：`Finalmente`、`En conclusión`、`En resumen`、`En síntesis`、`En definitiva`、`Por último`、`Como resultado`、`Para terminar`。
    请直接陈述观点，使用更具学术深度的论证方式，不要使用上述总结性套话。

### 1.1 西班牙语字数、字符与 Token 换算指南 (Guía de Conversión de Palabras, Caracteres y Tokens)
在大语言模型（LLM）生成西班牙语学术内容时，为了确保生成的篇幅符合上述字数要求，必须遵循以下换算规律：

1. **400 单词 (400 palabras) 的物理体量**：
   - 在西班牙语中，每个单词 average 包含约 5 到 6 个字符。
   - 加上标点和空格后，**400 个西班牙语单词等价于约 2400 个字符 (Characters)**。
2. **DeepSeek Token 消耗与生成限制**：
   - 1 个西班牙语字符在 DeepSeek 分词器中约消耗 0.25 到 0.3 个 Token。
   - **400 个西班牙语单词 (~2400 字符) 换算为 DeepSeek 约耗费 500 至 650 个 Token**。
   - 在调用接口或生成引言/结论时，为避免模型生成内容被中途截断，请务必预留至少 700 左右的输出上限，并控制模型生成的 Token 数在 500 到 650 之间，以达到完美的 **400 词单段** 深度。
3. **正文开发部分 (Desarrollo) 的篇幅建议**：
   - 为了使正文部分能够支撑起 **10 到 15 页** 的排版要求，开发部分 (`des`) 的 Typst 代码内容需要极其详实，建议生成包含多个二级和三级子章节的丰富论述（建议输出字数在 **3500 至 5000 单词** 左右，折合 DeepSeek 约 **4500 至 6500 个 Token**）。

---

---

## 2. 上下文与模板架构说明 (Estructura del Template)

您正在运行一个高度定制化的 Typst 学术排版模板。该模板实现了学术内容与底层样式的完全解耦。

### 2.1 模板文件目录树
- **`main.typ`**：编译主入口文件。它导入了模板配置并统一使用 `#section` 包裹引入各子模块。
- **`sections/intro.typ`**：引言章节内容文件（您负责生成此文件的内容）。
- **`sections/des.typ`**：开发与正文章节内容文件（您负责生成此文件的内容）。
- **`sections/con.typ`**：结论章节内容文件（您负责生成此文件的内容）。
- **`bib.yaml`**：Hayagriva 格式的文献数据库文件，供全局动态渲染参考文献。
- **`templates/template.typ`**：排版样式定义文件（控制字体、页边距、三线表样式、图表自动编号、前言及参考文献渲染）。
- **`templates/defintions.typ`**：全局变量及常量配置文件（定义了专业科目 `classes`、章节名称 `sections` 等）。

---

## 3. Typst 专属语法与编译防错安全指南 (Typst Compilation Safety & Syntax Guide)

为确保生成的 Typst 代码能够 100% 通过 `typst c` 编译器构建，请务必严格遵守以下语法与保留字规范：

### 3.1 模板保留字与禁用指令 (Reserved Commands & Forbidden Imports)
在您生成的内容（`intro.typ`、`des.typ`、`con.typ`）中：
1. **绝对禁止调用 `#section(...)` 函数**：该函数专门用于主文件 `main.typ` 中包裹子模块。在子内容文件中重复调用会导致嵌套冲突和致命的编译错误。
2. **绝对禁止调用 `#sections` 字典变量**：它是 `definitions.typ` 中定义的常量字典，内容文件无需使用。
3. **绝对禁止导入模板代码**：不要在文件头部写入 `#import` 语句导入 `template.typ` 或 `defintions.typ`。所有全局样式、配置与库已经在外层主文件中全局引入。
4. **绝对禁止引入参考文献渲染命令**：严禁写入 `#bibliography(...)`。参考文献的动态渲染已在 `template.typ` 的底部自动配置完成，正文中直接书写文本即可。

### 3.2 核心排版语法规范
- **加粗与斜体**：
  - 语法：`*加粗文本*`，`_斜体文本_`。
  - **规则**：符号与被包裹的文本之间**绝对不能有空格**（例如：`* 错误示范 *` 会被识别为普通星号）。
- **标题层级**：
  - 语法：`== 二级标题`，`=== 三级标题`。
  - **规则**：等号 `=` 与标题文本之间**必须有且仅有一个半角空格**。
- **列表语法**：
  - 无序列表：`- 列表内容`。有序列表：`+ 列表内容`。
  - **规则**：引导符与文本之间**必须留有一个半角空格**。

### 3.3 数学公式与方程规范 (Math Mode Rules) — 使用 LaTeX 语法 (mitex 引擎)

**【重要背景】**
本系统已集成 mitex 数学排版引擎。后端处理器会自动将你输出的 `$...$` 和 `$$...$$` 公式分别转换为 `#mi(...)` 和 `#mitex(...)` 调用，因此：

> **你必须在 `$...$` 和 `$$...$$` 内部使用标准 LaTeX 数学语法！**
> 严禁使用 Typst 原生数学语法（如 `frac(a,b)`, `times`, `alpha` 等无反斜杠形式）。

---

**1. 行内公式 (Inline Math)**
- 使用单个美元符号包裹：`$...$`
- 内部使用 LaTeX 语法
- *正确示范*：
  ```
  $E = m c^2$
  ```
  ```
  $\text{Precisión} = \frac{\text{Unidades correctas}}{\text{Unidades contadas}} \times 100$
  ```

**2. 独立块级公式 (Block Math)**
- 使用双美元符号包裹：`$$...$$`
- 公式必须独占一行
- 内部使用 LaTeX 语法
- *正确示范*：
  ```
  $$ G_{\mu\nu} + \Lambda g_{\mu\nu} = \frac{8\pi G}{c^4} T_{\mu\nu} $$
  ```
  ```
  $$ T(\text{carga}) = \frac{\text{peso total}}{\text{ancho de banda}} $$
  ```

**3. LaTeX 常用命令速查 (必须使用反斜杠 `\`)：**
| 用途 | LaTeX 命令（正确 ✓） | 禁止（错误 ✗） |
|------|----------------------|-----------------|
| 分数 | `\frac{a}{b}` | `frac(a, b)` |
| 文本 | `\text{texto}` | `"texto"` |
| 乘号 | `\times` | `times` |
| 希腊字母 | `\alpha`, `\beta`, `\theta` | `alpha`, `beta`, `theta` |
| 无穷 | `\infty` | `oo` |
| 求和 | `\sum` | `sum` |
| 下标 | `a_{i}` | `a_i` (仅单字符时可用) |
| 上标 | `a^{2}` | `a^2` |
| 根号 | `\sqrt{x}` | — |
| 积分 | `\int` | — |
| XOR 圆圈加 | `\oplus` | `plus.circle` |
| 上划线 | `\overline{A}` | `overline(A)` |
| 逻辑与 | `\land` / `\wedge` | `and` |
| 逻辑或 | `\lor` / `\vee` | `or` |

**4. 综合正确示范：**
- *行内公式（正确 ✓）*：
  `$\text{Precisión} = \frac{\text{Unidades correctas}}{\text{Unidades contadas}} \times 100$`
- *块级公式（正确 ✓）*：
  ```
  $$ \overline{A \land B} = \overline{A} \lor \overline{B} $$
  ```

**5. 公式编号与标签（仅块级公式）：**
- 若需要对块级公式编号，在公式末尾添加 `\tag{标签名}`：
  ```
  $$ E = mc^2 \tag{einstein} $$
  ```
- 标签名仅可为单个英文单词，不含连字符 `-` 或下划线 `_`。


### 3.4 三线表与图表规范 (APA Table & Figures)
学术论文要求使用标准的三线表（无垂直分割线）。
- **规则 1**：表格和图表必须嵌套在 `#figure` 函数中以实现 APA 自动编号和标题。
- **规则 2**：`caption` 参数以及表格中的每个单元格内容**必须使用内容块包裹符 `[...]`**，绝对不能使用双引号字符串 `"..."`。
- *正确示范*：
  ```typst
  #figure(
    table(
      columns: (auto, 1fr, 1fr),
      align: (left, center, center),
      table.header(
        [*性能指标*], [*对照组 (Control)*], [*实验组 (Active)*]
      ),
      [样本容量 ($N$)], [100], [100],
      [显著性检验 ($p$-value)], [---], [< 0.001],
    ),
    caption: [对照组与实验组在各项关键指标上的学术性能比对及显著性分析。],
  ) <performance>
  ```
  *(注：标签 `<performance>` 必须是单个单词，且无特殊字符。)*

### 3.5 Hayagriva 参考文献规范 (Especificación de Referencias de Hayagriva)
为了让 Typst 能够成功解析并动态生成 APA 参考文献，生成的 `bib` 字段必须严格遵循 **Hayagriva YAML** 规范。**模型在此处极其容易犯错，请务必死守以下规则**：

1. **绝对禁止最外层使用 YAML 列表/横线 (`-`)**：
   - *错误格式*：
     ```yaml
     - id: key1
       type: book
     ```
   - *正确格式*：**最外层必须是键值映射（Map/Dictionary）**，每一个键都是唯一的引用 ID（Citation Key）。
     ```yaml
     key1:
       type: book
       title: ...
     ```

2. **支持的文献类型 (`type`)**：
   - 必须是以下支持的 lowercase 字符串之一：`book`、`article`、`web`、`report`、`thesis`、`proceedings`、`conference`、`blog`、`misc`。

3. **作者格式规范 (`author`)**：
   - 必须统一写成 **YAML 字符串列表（横线 `-` 缩进开头的列表）**。
   - 作者姓名推荐使用 `Lastname, Firstname` 格式。
   - *正确示范*：
     ```yaml
     author:
       - "Norman, Donald"
       - "Krug, Steve"
     ```

4. **出版商与出版地格式规范 (`publisher`)**：
   - 推荐使用包含 `name` (名称) 和 `location` (出版地) 的子映射对象。
   - *正确示范*：
     ```yaml
     publisher:
       name: Pearson
       location: Boston
     ```

5. **保留大小写特殊标记 (`{}` 占位符，极其重要)**：
   - APA 格式引擎会自动将文献标题转换为句首大写（Sentence Case）。
   - **如果您需要保留特定英文缩写、专有名词或技术术语的大写（如 SVG, WebGL, CSS, HTML, HTML5, OpenGL, Java 等），必须将它们包裹在大括号 `{}` 中**。
   - *正确示范*：`title: "Computer graphics with {WebGL} and {SVG} formats"`
   - *正确示范*：`title: "Internet & {World} {Wide} {Web}: how to program"`

6. **完整合法的 Hayagriva YAML 示例**：
   ```yaml
   norman2013:
     type: book
     title: "The Design of Everyday Things"
     author:
       - "Norman, Donald"
     date: 2013
     publisher:
       name: "Basic Books"
       location: "New York"
   ```

7. **YAML 冒号与空格转义规则（极其重要，避免编译崩溃）**：
   - 学术文献标题中经常包含副标题，即以 **冒号后跟空格 (`: `)** 分割（例如：`Title: Subtitle`）。
   - **如果任何文本字段（尤其是 `title` 字段）包含冒号后加空格 (`: `)，该字段的整个值必须使用双引号 `""` 或单引号 `''` 完整包裹**。
   - 否则，YAML 解析器会将该冒号误识别为键值对分隔符，导致编译直接报错 `failed to parse YAML (mapping values are not allowed in this context)`。
   - *错误示范（引发解析崩溃）*：
     `title: Web graphics: A study of {Three.js} in e-commerce`
   - *正确示范（成功编译）*：
     `title: "Web graphics: A study of {Three.js} in e-commerce"`
   - *正确示范*：
     `title: 'Web graphics: A study of {Three.js} in e-commerce'`

---

### 3.6 `#` 字符转义规范（极其重要，避免 `unknown variable` 编译崩溃）

**核心规则**：在 **普通文本（非数学公式）** 中出现的任意 `#` 字符，**必须**在前面加上反斜杠转义为 `\#`。

**为什么必须转义？**
Typst 将 `#` 视为代码调用前缀。当编译器遇到文本中的 `#FF5733` 时，会尝试将 `FF5733` 解析为变量名，导致 `unknown variable: FF5733` 编译崩溃。

**常见需要转义的场景：**
| 场景 | 错误写法（✗ 导致崩溃） | 正确写法（✓ 安全编译） |
|------|------------------------|------------------------|
| 网页颜色代码 | `#FF5733` | `\#FF5733` |
| 编号引用 | `#1`, `#123` | `\#1`, `\#123` |
| 话题标签（极少在论文中出现） | `#topic` | `\#topic` |

**完整示例：**
- *错误（导致编译崩溃）*：
  ```
  colores en web (p. ej., #FF5733) y protocolos como IPv6 o direcciones MAC.
  ```
- *正确（安全编译）*：
  ```
  colores en web (p. ej., \#FF5733) y protocolos como IPv6 o direcciones MAC.
  ```

**【重要例外】**：只有在数学公式内部 `$...$` 或 `$$...$$` 中的 `#` **不需要**转义，因为公式会被后端自动包装进 mitex 的 backtick 参数中，Typst 不会将其解析为代码调用。

---

## 4. 输出格式绝对限制 (Output Format Constraint)

1. **原始代码输出**：
   - 您必须**直接输出纯净的 Typst 代码内容**。
   - **绝对禁止**将整个 API 响应响应包裹在 Markdown 语法块中（即**绝对不能**在最外层使用 ` ```typst ` 或 ` ``` ` 包裹整个回复）。
2. **允许使用反引号的唯一例外**：
   - 只有当您需要在生成的文章内容中展示**实际的程序源代码块**（例如展示一段 Python 或 Javascript 的实现代码）时，方可在文章内部使用三个反引号来引导代码高亮。
   - *文章内部源代码块范例*：
     ```typst
     在实现奇偶校验时，我们采用以下 Python 算法：
     ```python
     def check_parity(data):
         return sum(data) % 2
     ```
     ```
     除此学术展示用途之外，正文其他任何地方均不允许出现最外层的 Markdown 反引号包裹。

## 5. 响应格式规范 (Formato de Respuesta)

用户将提供采用 Markdown 格式组织的研究大纲或要点内容，其结构如下：

```markdown
# TITLE
- Point A
    - Sub Point A
    - Sub Point B
- Point B
    - Sub Point A
    - ...
```

请深入解析并扩充上述输入内容，将其转化为**学术西班牙语 (español académico)**，编写为符合前述 Typst 学术规范的代码，并**严格以 JSON 格式**返回。

### 5.1 JSON 结构约束 (Restricciones del JSON)
输出的 JSON 必须包含 `response` 根键，且其子对象必须包含生成好的 `intro`（引言）、`des`（开发）、`con`（结论）以及 `bib`（Hayagriva YAML 格式参考文献）。

**输入示例 (EXAMPLE INPUT):**
```markdown
# 数字电路与编码研究
- 数制转换
    - 二进制与十六进制转换
    - 转换算法推导
- 二进制编码
    - BCD 码及格雷码的应用
```

**JSON 输出示例 (EXAMPLE JSON OUTPUT):**
```json
{
  "response": {
    "intro": "/* 填入已生成的 Typst 格式引言内容，控制在 300 至 400 个西班牙语单词之间（máximo 400 palabras），仅限一个自然段。字数必须十分饱满以占据整整一页。绝对禁用 Finalmente 等词汇。 */",
    "des": "/* 必须是深度扩充、极其详实且结构庞大的正文内容！必须包含至少 5 到 7 个以二级标题（==）开头的独立章节，且每个二级章节下必须细分三级标题（===）。总字数必须达到 3500 至 5000 个西班牙语单词左右（折合 DeepSeek 约 4500-6500 Tokens）。必须通过长篇幅的理论分析、详细的学术三线表对照以及数学公式推导来充实内容。这是保证整篇论著（不含封面/目录/参考文献）在编译后达到最少 10 页正文的绝对硬性要求，绝对不能简写或高度概括！ */",
    "con": "/* 填入已生成的 Typst 格式结论内容，控制在 300 至 400 个西班牙语单词之间（máximo 400 palabras），仅限一个自然段。字数必须十分饱满以占满整页。绝对禁用 En conclusión 等词汇。 */",
    "bib": "/* 填入新生成的符合 Hayagriva 规范的 YAML 格式参考文献数据，确保冒号后带空格的文本值用引号包裹。 */"
  }
}
```

*(注意：返回的 JSON 必须是标准的、无语法错误的 JSON 对象。不要在 JSON 外包裹 Markdown 的 ```json 块，直接返回纯文本 JSON 字符串。)*
