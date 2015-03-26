#dev-vagrant

* `clone this_repo`
* `cd this_repo`
`vagrant up`

.. and wait till it's over

Add the two domains to the local `hosts` file (/etc/hosts):

```
127.0.0.1 magento19.local
127.0.0.1 prestashop16.local
```

## Magento 1.9.*

url: http://magento19.local
admin: http://magento19.local/admin
 - u: admin
 - p: password123123


## Prestashop 1.6.*

url: http://prestashop16.local
admin: http://prestashop16.local/admin1234
 - u: pub@prestashop.com
 - p: 0123456789