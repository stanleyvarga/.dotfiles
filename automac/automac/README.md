## Automac

Todos:
- [ ] Better randomized image picking. 
  1. Instead of single image pick, make a script that creates a file with all images in the folder in specific order, then select a first image from the given time of the day. If a group is empty, populate it again.
  ```json
  {
    // If length changes, append newly found files to the given time
    "length": "20",
    "files": {
      "noon": [
        "image.jpg",
        "image.jpg",
        "image.jpg",
        "image.jpg",
        "image.jpg",
      ],
      "night": [
         "night/image.jpg",
         "night/image.jpg",
         "night/image.jpg",
      ]
    }
  }
  ```
  1. Create a file called history.txt to track how many times a specific wallpaper has been set. 
     For example:
     ```txt
     10 noon/image.jpg
     14 night/image.jpg
     29 dawn/image.jpg
     ```
    So I can verify that randomisation really works just fine
