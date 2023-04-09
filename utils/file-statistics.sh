#!/bin/bash

# Number of total org files
find . -iname "*.org" | wc -l
# Number of total org files (sorted desc by lines)
find . -iname "*.org" | wc -l | sort -nr

# Create a csv file with information about each file
now="$(date +'%Y-%m-%d %H:%M:%S')"
echo "lines,words,bytes,path" > "statistics $now.csv"
find . -iname "*.org" -exec bash -c 'wc "{}"' \; | \
sed -E 's/[ ]*([0-9]+)[ ]+([0-9]+)[ ]+([0-9]+)[ ]+/\1,\2,\3,/g' >> "statistics $now.csv"

# Create a csv file with information about each file (sorted desc by lines)
now="$(date +'%Y-%m-%d %H:%M:%S')"
echo "lines,words,bytes,path" > "statistics $now.csv"
find . -iname "*.org" -exec bash -c 'wc "{}"' \; | \
sed -E 's/[ ]*([0-9]+)[ ]+([0-9]+)[ ]+([0-9]+)[ ]+/\1,\2,\3,/g' | sort -nr >> "statistics $now.csv"

# Count how many links of each website you have
rg --no-filename -o "https?://[^/]+" | sed -E "s#https?://[^/]+\zs.*##" | sort | uniq -c | sort -nr | less

# Count how many link to another notes there are (only id and file:... .org)
now="$(date +'%Y-%m-%d %H:%M:%S')"
echo "links,path" > "link statistics $now.csv"
grep -Fc -e "[[id:" -e ".org]" *.org */*.org | sed -E 's/^([^:]+):(.+)/\2,\1/' | sort -nr >> "link statistics $now.csv"


now="$(date +'%Y%m%d%H%M%S')"
echo "links,path" > "creation_date_$now.csv"
find -iname "*.org" -exec /bin/bash -c 'echo $(git --no-pager log --diff-filter=A --follow --format=%aI -1 -- {}),{}' \; >> "creation_date_$now.csv"


now="$(date +'%Y%m%d%H%M%S')"
echo "links,path" > "creation_date_$now.csv"
find -iname "*.org" -exec /bin/bash -c 'echo $(git --no-pager log --diff-filter=A --follow --format=%aI -1 -- {}),{}' \; | sort -nr >> "creation_date_$now.csv"


# find last commit for each file
now="$(date +'%Y%m%d%H%M%S')"
echo "date,path" > "last_commit_$now.csv"
find -iname '*.org' -exec git --no-pager log -1 --date=iso8601 --pretty='%aI,{}' -- '{}' \; | sed 's#./##' > "last_commit_$now.csv"

# find last commit for each file (sorted asc by date)
now="$(date +'%Y%m%d%H%M%S')"
echo "date,path" > "last_commit_$now.csv"
find -iname '*.org' -exec git --no-pager log -1 --date=iso8601 --pretty='%aI,{}' -- '{}' \; | sed 's#./##' | sort -n > "last_commit_$now.csv"


# find 100th most recent commit for each file
now="$(date +'%Y%m%d%H%M%S')"
echo "date,path" > "last_commit_$now.csv"
find -iname '*.org' -exec git --no-pager log -1 --skip=100 --date=iso8601 --pretty='%aI,{}' -- '{}' \; | sed 's#./##' > "last_commit_$now.csv"

# find 100th most recent commit for each file (sorted desc by date)
now="$(date +'%Y%m%d%H%M%S')"
echo "date,path" > "last_commit_$now.csv"
find -iname '*.org' -exec git --no-pager log -1 --skip 100 --date=iso8601 --pretty='%aI,{}' -- '{}' \; | sed 's#./##' | sort -n > "last_commit_$now.csv"

now="$(date +'%Y%m%d%H%M%S')"
echo "date|path" > "all_commits_$now.csv"
find -iname '*.org' -exec git --no-pager log --exclude=12d46748e --exclude=12d46748e --date=iso8601 --pretty='%aI|{}' -- '{}' \; | tqdm | sed 's#./##' >> "all_commits_$now.csv"
python <<-EOF
import pandas as pd
import numpy as np
def quantile(q):
    def quantile(x):
        return x.quantile(q)
    quantile.__name__ = f'q{q}'
    return quantile
df = pd.read_csv('all_commits_$now.csv', sep='|')
df = df[~(df['path'].str.contains('zz-ice-cube/') | df['path'].str.contains('snowflake/'))]
df['date'] = (pd.Timestamp.utcnow() - pd.to_datetime(df['date'], utc=True)).dt.total_seconds()
df = df.transform({'date': lambda x: np.log10(x/3600), 'path': lambda x: x}).groupby('path') \
.agg([quantile(n) for n in np.logspace(-5, 0, 6)])
df['mean_date'] = df['date'].apply(np.mean, axis=1)
df['std_date'] = df['date'].apply(np.std, axis=1)
df.columns = [first if first != '' else second for first, second in zip(df.columns.get_level_values(1), df.columns.get_level_values(0))]
df.style.background_gradient(cmap='coolwarm_r').to_excel("coolwarm_$now.xlsx", engine="openpyxl")
EOF

# find number of unique ids
rg -I ":ID:" | wc -l
