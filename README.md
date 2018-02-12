SAND Cookbook
================

Install [SAND Network Daemon](https://github.com/Scalingo/sand)

Requirements
------------

None, this is Go !

Attributes
----------

e.g.
#### sand::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['sand']['download_url']</tt></td>
    <td>string</td>
    <td>Download URL of binary archive</td>
    <td><tt>https://github.com/Scalingo/sand/releases/download/</tt></td>
  </tr>
  <tr>
    <td><tt>['sand']['version']</tt></td>
    <td>string</td>
    <td>Version of the executable</td>
    <td><tt>v0.2.0</tt></td>
  </tr>
  <tr>
    <td><tt>['sand']['arch']</tt></td>
    <td>string</td>
    <td>Target architecture</td>
    <td><tt>amd64</tt></td>
  </tr>
  <tr>
</table>

See https://github.com/Scalingo/sand-cookbook/blob/master/attributes/default.rb for details

Usage
-----
#### sand::default

Just include `sand` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[sand]"
  ]
}
```

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Léo Unbekandt `leo@scalingo.com`
