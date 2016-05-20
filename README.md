# opsinterview-cookbook

Create an EC2 Instance for the DevOps Linux and Scripting interview exercise.

```
export AWS_ACCESS_KEY=your-aws-access-key-id
export AWS_SECRET_KEY=your-aws-secret-key
```

## Supported Platforms

Ubuntu-14.04
## Attributes

Currently no attributes.

## Usage
```
kitchen converge
```

### opsinterview::default

Include `opsinterview` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[opsinterview::default]"
  ]
}
```

## License and Authors

Author:: Art Witczak (art.witczak@rallyhealth.com>)
