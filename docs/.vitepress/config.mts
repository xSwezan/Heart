import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "Heart",
  description: "A Love2D Framework",
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { text: 'Home', link: '/' },
      { text: 'API', link: '/api/api' },
      { text: 'Examples', link: '/input' }
    ],

    sidebar: [
      {
        text: 'Introduction',
        items: [
          { text: 'Getting Started', link: '/getting-started' }
        ]
      },
      {
        text: 'Examples',
        items: [
          { text: 'Handling Input', link: '/examples/input' },
          { text: 'Creating sprites', link: '/examples/creating-sprites' },
          { text: 'Task library', link: '/examples/task-library' }
        ]
      },
      {
        text: 'API',
        items: [
          {
            text: 'Heart',
            link: '/api/heart',
            items: [
              {
                text: 'Task',
                link: '/api/task'
              },
              {
                text: 'Input',
                link: '/api/input'
              },
              {
                text: 'Sound',
                link: '/api/sound'
              },
              {
                text: 'Spring',
                link: '/api/spring',
              },
              {
                text: 'Canvas',
                link: '/api/canvas',
              },
              {
                text: 'Shader',
                link: '/api/shader',
              },
              {
                text: 'Font',
                link: '/api/font',
              },
              {
                text: 'Vector2',
                link: '/api/vector2',
              },
              {
                text: 'Rect2D',
                link: '/api/rect2d',
                items: [
                  {
                    text: 'Sprite',
                    link: '/api/sprite'
                  },
                  {
                    text: 'Label',
                    link: '/api/label'
                  },
                  {
                    text: 'Frame',
                    link: '/api/frame'
                  },
                ]
              }
            ]
          }
        ]
      }
    ],
    logo: '/icon.svg',

    socialLinks: [
      { icon: 'github', link: 'https://github.com/xSwezan/Heart' }
    ]
  },
  head: [
    ['link', { rel: 'icon', href: '/icon.svg' }]
  ]
})
