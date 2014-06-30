# Description

New-Relic plugin to monitor your google cloud storage activity.  
A key point to keep backups in sight !  
**Check my [other repo](https://github.com/nkcr/Google-Cloud-Storage-Upload) to kackup your database on google cloud storage !**
<p align="center"><img src="http://s27.postimg.org/p8rtjh2db/Untitled_1.png"></p>

## Metrics

- Total size 
- Total elements
- Size rate
- Elements rate
- Number of new elements within a day
- Size gained within a day

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

For ubuntu and debian install bundler (and also ruby if needed) with :

        $ sudo apt-get install bundler

----

# Installation

- Get the plugin folder and place it where you want
- Inside the folder run

        $ bundle install
        
This should install the newrelic and google SDK

- Fill the config/newrelic_plugin.yml file :

| Parameter                   | Description         |
| :-------------------------- | :---------------    |
| google_storage_key_path     | The relative path of your _service account key_ |
| google_storage_key_secret   | The secret of your key (default is _notasecret_) |
| google_storage_mail         | The email that goes with your _service account key_, like _xxxxxxx-xxxxx@developper.gserviceaccount.com_ |
| google_storage_project_id   | The ID of your google Project (the one that contains your bucket) |
| google_storage_bucket_name  | The name of your bucket (the one you wish to monitor) |
| element_offset_alert        | Used to monitor the number of new elements per day. That value minus the number of new elements will be the value monitored. Like that we know there is a problem when the value is above the expected one. |
| size_offset_alert           | Like element_offset_alert but for the size. If you upload less than a gigabyte per day leave the default value |
    
- And finally, run the script with

        $ ruby /path/to/script/folder/newrelic_gcstorage_agent.rb
        
- You can also launch it as a deamon with 

        $ ./path/to/.../deamon.rb start
    
---

# Alerts

On newrelic, alerts only work when a value is above the expected one. To work with it, you can use _Alert/elements_ and _Alert/size_. Those values work with the ones in the config file : _element_offset_alert_ and _size_offset_alert_.  
_Alert/elements_ is _element_offset_alert_ minus the number of new elements per day. If your expecting 4 new elements per day and _element_offset_alert_ = 100, you will set your alert threshold to 93. The same for _size_offset_alert_.

---

# Source

Get the source [here](https://github.com/nkcr/Google-Cloud-Storage-Metric), download it as ZIP file and unzip it on your computer.

---

# License

Licensed under the The MIT License (MIT).

----

# Support

For any support contact me on github. Please report new issues if found.  

----
