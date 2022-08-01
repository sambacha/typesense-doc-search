# `typesense-doc-search`

> typesense scraper 

[docscraper docs](https://typesense.org/docs/guide/docsearch.html#step-1-set-up-docsearch-scraper)

### setup
~~~bash
mkdir -p /etc/indexer
cd /etc/indexer
git clone https://github.com/sambacha/typesense-doc-search
chmod +x setup.sh
sudo ./setup.sh
~~~

### run

```bash
export TYPESENSE_HOST=host.docker.internal
docker run -it --env-file=/path/to/your/.env -e \
  "CONFIG=$(cat /path/to/your/config.json | jq -r tostring)" typesense/docsearch-scraper
```

#### docker-compose

```yaml
extra_hosts:
- "host.docker.internal:host-gateway"
```
