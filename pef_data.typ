// Some definitions presupposed by pandoc's typst output.
#let blockquote(body) = [
  #set text( size: 0.92em )
  #block(inset: (left: 1.5em, top: 0.2em, bottom: 0.2em))[#body]
]

#let horizontalrule = [
  #line(start: (25%,0%), end: (75%,0%))
]

#let endnote(num, contents) = [
  #stack(dir: ltr, spacing: 3pt, super[#num], contents)
]

#show terms: it => {
  it.children
    .map(child => [
      #strong[#child.term]
      #block(inset: (left: 1.5em, top: -0.4em))[#child.description]
      ])
    .join()
}

// Some quarto-specific definitions.

#show raw.where(block: true): set block(
    fill: luma(230),
    width: 100%,
    inset: 8pt,
    radius: 2pt
  )

#let block_with_new_content(old_block, new_content) = {
  let d = (:)
  let fields = old_block.fields()
  fields.remove("body")
  if fields.at("below", default: none) != none {
    // TODO: this is a hack because below is a "synthesized element"
    // according to the experts in the typst discord...
    fields.below = fields.below.amount
  }
  return block.with(..fields)(new_content)
}

#let empty(v) = {
  if type(v) == "string" {
    // two dollar signs here because we're technically inside
    // a Pandoc template :grimace:
    v.matches(regex("^\\s*$")).at(0, default: none) != none
  } else if type(v) == "content" {
    if v.at("text", default: none) != none {
      return empty(v.text)
    }
    for child in v.at("children", default: ()) {
      if not empty(child) {
        return false
      }
    }
    return true
  }

}

// Subfloats
// This is a technique that we adapted from https://github.com/tingerrr/subpar/
#let quartosubfloatcounter = counter("quartosubfloatcounter")

#let quarto_super(
  kind: str,
  caption: none,
  label: none,
  supplement: str,
  position: none,
  subrefnumbering: "1a",
  subcapnumbering: "(a)",
  body,
) = {
  context {
    let figcounter = counter(figure.where(kind: kind))
    let n-super = figcounter.get().first() + 1
    set figure.caption(position: position)
    [#figure(
      kind: kind,
      supplement: supplement,
      caption: caption,
      {
        show figure.where(kind: kind): set figure(numbering: _ => numbering(subrefnumbering, n-super, quartosubfloatcounter.get().first() + 1))
        show figure.where(kind: kind): set figure.caption(position: position)

        show figure: it => {
          let num = numbering(subcapnumbering, n-super, quartosubfloatcounter.get().first() + 1)
          show figure.caption: it => {
            num.slice(2) // I don't understand why the numbering contains output that it really shouldn't, but this fixes it shrug?
            [ ]
            it.body
          }

          quartosubfloatcounter.step()
          it
          counter(figure.where(kind: it.kind)).update(n => n - 1)
        }

        quartosubfloatcounter.update(0)
        body
      }
    )#label]
  }
}

// callout rendering
// this is a figure show rule because callouts are crossreferenceable
#show figure: it => {
  if type(it.kind) != "string" {
    return it
  }
  let kind_match = it.kind.matches(regex("^quarto-callout-(.*)")).at(0, default: none)
  if kind_match == none {
    return it
  }
  let kind = kind_match.captures.at(0, default: "other")
  kind = upper(kind.first()) + kind.slice(1)
  // now we pull apart the callout and reassemble it with the crossref name and counter

  // when we cleanup pandoc's emitted code to avoid spaces this will have to change
  let old_callout = it.body.children.at(1).body.children.at(1)
  let old_title_block = old_callout.body.children.at(0)
  let old_title = old_title_block.body.body.children.at(2)

  // TODO use custom separator if available
  let new_title = if empty(old_title) {
    [#kind #it.counter.display()]
  } else {
    [#kind #it.counter.display(): #old_title]
  }

  let new_title_block = block_with_new_content(
    old_title_block, 
    block_with_new_content(
      old_title_block.body, 
      old_title_block.body.body.children.at(0) +
      old_title_block.body.body.children.at(1) +
      new_title))

  block_with_new_content(old_callout,
    block(below: 0pt, new_title_block) +
    old_callout.body.children.at(1))
}

// 2023-10-09: #fa-icon("fa-info") is not working, so we'll eval "#fa-info()" instead
#let callout(body: [], title: "Callout", background_color: rgb("#dddddd"), icon: none, icon_color: black) = {
  block(
    breakable: false, 
    fill: background_color, 
    stroke: (paint: icon_color, thickness: 0.5pt, cap: "round"), 
    width: 100%, 
    radius: 2pt,
    block(
      inset: 1pt,
      width: 100%, 
      below: 0pt, 
      block(
        fill: background_color, 
        width: 100%, 
        inset: 8pt)[#text(icon_color, weight: 900)[#icon] #title]) +
      if(body != []){
        block(
          inset: 1pt, 
          width: 100%, 
          block(fill: white, width: 100%, inset: 8pt, body))
      }
    )
}



#let article(
  title: none,
  subtitle: none,
  authors: none,
  date: none,
  abstract: none,
  abstract-title: none,
  cols: 1,
  margin: (x: 1.25in, y: 1.25in),
  paper: "us-letter",
  lang: "en",
  region: "US",
  font: "linux libertine",
  fontsize: 11pt,
  title-size: 1.5em,
  subtitle-size: 1.25em,
  heading-family: "linux libertine",
  heading-weight: "bold",
  heading-style: "normal",
  heading-color: black,
  heading-line-height: 0.65em,
  sectionnumbering: none,
  toc: false,
  toc_title: none,
  toc_depth: none,
  toc_indent: 1.5em,
  doc,
) = {
  set page(
    paper: paper,
    margin: margin,
    numbering: "1",
  )
  set par(justify: true)
  set text(lang: lang,
           region: region,
           font: font,
           size: fontsize)
  set heading(numbering: sectionnumbering)
  if title != none {
    align(center)[#block(inset: 2em)[
      #set par(leading: heading-line-height)
      #if (heading-family != none or heading-weight != "bold" or heading-style != "normal"
           or heading-color != black or heading-decoration == "underline"
           or heading-background-color != none) {
        set text(font: heading-family, weight: heading-weight, style: heading-style, fill: heading-color)
        text(size: title-size)[#title]
        if subtitle != none {
          parbreak()
          text(size: subtitle-size)[#subtitle]
        }
      } else {
        text(weight: "bold", size: title-size)[#title]
        if subtitle != none {
          parbreak()
          text(weight: "bold", size: subtitle-size)[#subtitle]
        }
      }
    ]]
  }

  if authors != none {
    let count = authors.len()
    let ncols = calc.min(count, 3)
    grid(
      columns: (1fr,) * ncols,
      row-gutter: 1.5em,
      ..authors.map(author =>
          align(center)[
            #author.name \
            #author.affiliation \
            #author.email
          ]
      )
    )
  }

  if date != none {
    align(center)[#block(inset: 1em)[
      #date
    ]]
  }

  if abstract != none {
    block(inset: 2em)[
    #text(weight: "semibold")[#abstract-title] #h(1em) #abstract
    ]
  }

  if toc {
    let title = if toc_title == none {
      auto
    } else {
      toc_title
    }
    block(above: 0em, below: 2em)[
    #outline(
      title: toc_title,
      depth: toc_depth,
      indent: toc_indent
    );
    ]
  }

  if cols == 1 {
    doc
  } else {
    columns(cols, doc)
  }
}

#set table(
  inset: 6pt,
  stroke: none
)

#show: doc => article(
  title: [5-Week Data Analysis Workshop for Economics & Social Sciences],
  authors: (
    ( name: [Zahid Asghar],
      affiliation: [],
      email: [] ),
    ),
  date: [2024-02-01],
  sectionnumbering: "1.1.a",
  toc: true,
  toc_title: [Workshop Plan],
  toc_depth: 2,
  cols: 1,
  doc,
)

= Workshop Overview
<workshop-overview>
This workshop is designed for participants in economics and social sciences interested in developing hands-on skills in data analysis using R. Sessions will run for 2 hours weekly across two days (Friday and Saturday, 6-8 PM). The workshop will focus on practical activities with guided facilitation for online learning.

== Workshop Objectives
<workshop-objectives>
- Develop skills in data handling, merging, and cleaning.
- Build competence in descriptive statistics, visualizations, and balance tables.
- Apply regression techniques like OLS, Logit/Probit, IV, and Difference-in-Differences.
- Encourage peer collaboration and hands-on data analysis.

#horizontalrule

= Week 1: Research Question & Data Handling
<week-1-research-question-data-handling>
#strong[Friday & Saturday (2-hour slots)]

#table(
  columns: (5.77%, 19.23%, 19.23%, 40.38%, 15.38%),
  align: (auto,auto,auto,auto,auto,),
  table.header([\#], [Duration], [Activity], [Facilitator Actions], [Output],),
  table.hline(),
  [1], [10 min], [Welcome & Icebreaker], [Share workshop goals, personal intros using "two truths and a lie"], [Participants connected],
  [2], [30 min], [Identifying a Research Question], [Guide brainstorming using a mind map], [List of potential research questions],
  [3], [20 min], [Sources of Data], [Present key sources for economic and social science datasets], [Awareness of data sources],
  [4], [40 min], [Hands-on: Loading & Exploring Datasets], [Guide participants through loading CSV datasets using R], [Loaded datasets],
  [5], [20 min], [Group Discussion: Variables & Structures], [Facilitate data structure analysis], [Identified key variables],
  [6], [20 min], [Merging Datasets], [Live demonstration and practice], [Successfully merged datasets],
)

#horizontalrule

= Week 2: Cleaning Data & Descriptive Statistics
<week-2-cleaning-data-descriptive-statistics>
#strong[Friday & Saturday (2-hour slots)]

#table(
  columns: (5.77%, 19.23%, 19.23%, 40.38%, 15.38%),
  align: (auto,auto,auto,auto,auto,),
  table.header([\#], [Duration], [Activity], [Facilitator Actions], [Output],),
  table.hline(),
  [1], [10 min], [Energizer], [Quick quiz on previous topics], [Active recall],
  [2], [30 min], [Identifying Missing Data], [Guide practical exercise using real data], [Cleaned dataset],
  [3], [30 min], [Outliers & Data Transformation], [Explain handling outliers & transformations], [Cleaned and transformed data],
  [4], [30 min], [Descriptive Statistics], [Hands-on calculations and interpretation], [Descriptive statistics],
  [5], [20 min], [Descriptive Charts], [Group activity to create histograms and boxplots], [Completed visualizations],
)

#horizontalrule

= Week 3: Balancing Tables & Ordinary Least Squares
<week-3-balancing-tables-ordinary-least-squares>
#strong[Friday & Saturday (2-hour slots)]

#table(
  columns: (5.77%, 19.23%, 19.23%, 40.38%, 15.38%),
  align: (auto,auto,auto,auto,auto,),
  table.header([\#], [Duration], [Activity], [Facilitator Actions], [Output],),
  table.hline(),
  [1], [10 min], [Icebreaker], [Group puzzle challenge], [Engaged participants],
  [2], [40 min], [Balancing Tables], [Hands-on creation of balancing tables], [Created balancing tables],
  [3], [50 min], [OLS Regression Explanation], [Visualizing OLS through scatter plots and coding in R], [Clear understanding of OLS],
  [4], [20 min], [Hands-on: Running OLS], [Guide participants through coding an OLS model], [Implemented OLS],
  [5], [20 min], [Group Reflection], [Discuss results and common errors], [Clarified common mistakes],
)

#horizontalrule

= Week 4: Logit, Probit & Instrumental Variables
<week-4-logit-probit-instrumental-variables>
#strong[Friday & Saturday (2-hour slots)]

#table(
  columns: (5.77%, 19.23%, 19.23%, 40.38%, 15.38%),
  align: (auto,auto,auto,auto,auto,),
  table.header([\#], [Duration], [Activity], [Facilitator Actions], [Output],),
  table.hline(),
  [1], [10 min], [Icebreaker], [Quick check-in], [Participants feel connected],
  [2], [40 min], [Logit & Probit Models], [Explain theory with real-world examples], [Conceptual clarity],
  [3], [50 min], [Hands-on: Logit & Probit], [Walkthrough coding and interpretation], [Participants ran models],
  [4], [40 min], [Instrumental Variables], [Explain concepts and coding practice], [Implemented IV analysis],
)

#horizontalrule

= Week 5: Difference-in-Differences & Wrap-Up
<week-5-difference-in-differences-wrap-up>
#strong[Friday & Saturday (2-hour slots)]

#table(
  columns: (5.77%, 19.23%, 19.23%, 40.38%, 15.38%),
  align: (auto,auto,auto,auto,auto,),
  table.header([\#], [Duration], [Activity], [Facilitator Actions], [Output],),
  table.hline(),
  [1], [10 min], [Icebreaker], [Reflection: "One thing I learned…"], [Reflective participants],
  [2], [45 min], [Difference-in-Differences Theory], [Explain concept with historical examples], [Theoretical understanding],
  [3], [50 min], [Hands-on: Difference-in-Differences], [Code-along for DiD estimation], [Ran DiD models],
  [4], [15 min], [Wrap-Up & Next Steps], [Feedback collection and next steps], [Participant feedback],
)

#horizontalrule

= Technical Requirements
<technical-requirements>
- #strong[Software];: R, RStudio, Quarto
- #strong[Packages Needed];: `tidyverse`, `haven`, `fixest`, `dplyr`, `ggplot2`
- #strong[File Sharing];: All materials and datasets will be shared via a cloud link before the session.

= Next Steps & Feedback
<next-steps-feedback>
- Workshop slides and datasets will be provided in a shared folder.
- Feedback will be collected at the end of the last session using a Google Form.

As discussed in #cite(<workshop-objectives>, form: "prose")
