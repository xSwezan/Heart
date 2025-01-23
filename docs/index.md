---
# https://vitepress.dev/reference/default-theme-home-page
layout: home

hero:
  name: "Heart"
  text: "A Roblox-style Love2D framework"
  tagline: A Roblox-style framework for Love2D
  image:
    src: /icon.svg
    alt: Heart
  actions:
    - theme: brand
      text: Getting started
      link: /getting-started
    - theme: alt
      text: API Examples
      link: /api-examples

features:
  - title: Roblox-styled
    icon: <svg width="400" height="400" viewBox="0 0 400 400" fill="none" xmlns="http://www.w3.org/2000/svg"><g clip-path="url(#clip0_1002_84)"><mask id="mask0_1002_84" style="mask-type:luminance" maskUnits="userSpaceOnUse" x="66" y="66" width="267" height="267"><path d="M333 66H66V333H333V66Z" fill="white"/></mask><g mask="url(#mask0_1002_84)"><path d="M131.403 81.6068L81.6207 267.743L267.757 317.569L317.539 131.433L131.403 81.6068ZM180.571 167.08L232.505 180.996L218.589 232.93L166.611 219.014L180.571 167.08Z" fill="white"/></g></g><defs><clipPath id="clip0_1002_84"><rect width="267" height="267" fill="white" transform="translate(66 66)"/></clipPath></defs></svg>
    details: Heart is designed to be like Roblox's Luau API.
  - title: Feature B
    details: Lorem ipsum dolor sit amet, consectetur adipiscing elit
  - title: Feature C
    details: Lorem ipsum dolor sit amet, consectetur adipiscing elit
---

<style>

:root {
  --vp-c-brand-1: #EA316E;
  --vp-c-brand-2: #EA316E;
  --vp-c-brand-3: #EA316E;

  --vp-home-hero-name-color: transparent;
  --vp-home-hero-name-background: -webkit-linear-gradient(25deg, #EA316E 10%, #EA316E);

  --vp-home-hero-image-background-image: linear-gradient(90deg, #EA316E 50%, #EA316E 50%);
  --vp-home-hero-image-filter: blur(44px);
}

@media (min-width: 640px) {
  :root {
    --vp-home-hero-image-filter: blur(56px) opacity(38%);
  }
}

@media (min-width: 960px) {
  :root {
    --vp-home-hero-image-filter: blur(68px) opacity(46%);
  }
}

</style>