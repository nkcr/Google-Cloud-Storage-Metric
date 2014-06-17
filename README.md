# Description

New-Relic plugin to monitor your google cloud storage activity.  
A key point to keep backups in sight !
<p align="center"><img src="http://s27.postimg.org/p8rtjh2db/Untitled_1.png"></p>

----

# Requirements

**Google cloud storage**

- Google developper account with cloud storage. See [here](https://cloud.google.com/products/cloud-storage/)
- Obviously, a _google project_ with a _bucket_. For help see [here](https://developers.google.com/storage/docs/overview)
- _Google cloud storage JSON API_ enabled. <p align="center">![img](http://s30.postimg.org/oe8wkrc35/Capture_d_cran_2014_06_16_13_14_25.png)</p>
- A _service account key_ along with his email address <p align="center"><img width="500px" src="http://s4.postimg.org/3nsu1labx/Capture_d_cran_2014_06_16_13_25_13.png"></p>

**Environment**

- Ruby
- Bundler

----

# Installation

- Get the plugin folder and place it where you want
- Inside the folder run

        $ bundle install
        
This should install the newrelic and google SDK

- Fill the config/newrelic_plugin.yml file :

| Paramater                   | Description         |
| :-------------------------- | :---------------    |
| google_storage_key_path     | The relative path of your _service account key_ |
| google_storage_key_secret   | The secret of your key (default is _notasecret_) |
| google_storage_mail         | The email that goes with your _service account key_, like _xxxxxxx-xxxxx@developper.gserviceaccount.com_ |
| google_storage_project_id   | The ID of your google Project (the one that contains your bucket) |
| google_storage_bucket_name  | The name of your bucket (the one you wish to monitor) |
    
- And finally, run the script with

        $ ruby /path/to/script/folder/newrelic_gcstorage_agent.rb
    
---

# Source

Get the source here, download it as ZIP file and unzip it on your computer.

---

# License

Licensed under the The MIT License (MIT).

----

# Support

For any support contact me on github.

----
