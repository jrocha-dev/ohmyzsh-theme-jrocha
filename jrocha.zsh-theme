# Jose Rocha theme

# Thanks to:
# [Writing ZSH Themes: A Quickref](https://blog.carbonfive.com/writing-zsh-themes-a-quickref/)
# [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh)
# [phmyzsh|Themes](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes)
# [ohmyzsh|Design](https://github.com/ohmyzsh/ohmyzsh/wiki/Design)

# ------------------------------------------------------------------------------
# Set up
# ------------------------------------------------------------------------------

setopt prompt_subst      # needed for zsh versions < 5.0.8
autoload -U add-zsh-hook # needed for zsh versions < 5.1.1
autoload -Uz vcs_info    # needed for zsh versions < 5.0.8

# colors cheme based on Gogh-Co's Clone Of Ubuntu (https://github.com/Gogh-Co/Gogh)
# And names are based on ANSI color escape codes (https://dev.to/ifenna__/adding-colors-to-bash-scripts-48g4)
# First testing if system support 256 colors (http://tobib.spline.de/xi/posts/2019-06-24-terminal-colors/)

Project_Root="/meu/teste"

# ------------------------------------------------------------------------------
# Color Scheme
# ------------------------------------------------------------------------------

#use extended color palette if available
if [[ $terminfo[colors] -ge 256 ]]; then

  # Colors cheme is based on Gogh-Co's Clone Of Ubuntu and are commented.
  # https://github.com/Gogh-Co/Gogh are the source of the colors scheme.
  # Using Xterm Number (https://www.ditig.com/256-colors-cheat-sheet)
  # for adapt colors cheme to 256 colors.

  # %F{color} is used to set foreground color, while %K{color} is used to set
  # background color. %f and %k are used to reset foreground and background

  Black="236"        #2E3436
  Red="160"          #CC0000
  Green="76"         #4E9A06
  Yellow="178"       #C4A000
  Blue="26"          #3465A4
  Magenta="165"      #75507B
  Cyan="51"          #06989A
  LightGray="252"    #D3D7CF
  Gray="240"         #555753
  LightRed="196"     #EF2929
  LightGreen="155"   #8AE234
  LightYellow="220"  #FCE94F
  LightBlue="75"     #729FCF
  LightMagenta="200" #AD7FA8
  LightCyan="87"     #34E2E2
  White="255"        #EEEEEC

else

  # 16 colors using standard (ANSI) names. See likns bellow:
  # https://dev.to/ifenna__/adding-colors-to-bash-scripts-48g4
  # https://i.stack.imgur.com/1BPuE.png

  Black="black"                #2E3436
  Red="red"                    #CC0000
  Green="green"                #4E9A06
  Yellow="yellow"              #C4A000
  Blue="blue"                  #3465A4
  Magenta="magenta"            #75507B
  Cyan="cyan"                  #06989A
  LightGray="white"            #D3D7CF
  Gray="brightblack"           #555753
  LightRed="brightred"         #EF2929
  LightGreen="brightgreen"     #8AE234
  LightYellow="brightyellow"   #FCE94F
  LightBlue="brightblue"       #729FCF
  LightMagenta="brightmagenta" #AD7FA8
  LightCyan="brightcyan"       #34E2E2
  White="brightwhite"          #EEEEEC

fi

# ------------------------------------------------------------------------------
# Environment Information
# ------------------------------------------------------------------------------

# Function to find package.json in the current directory or any parent directory

export VIRTUAL_ENV_DISABLE_PROMPT=1 # disable virtualenv prompt change

function find_python_project_root {
  local dir=$1
  while [[ "$dir" != "/" && ! -e "$dir/requirements.txt" && ! -e "$dir/Pipfile" && ! -e "$dir/setup.py" ]]; do
    dir=$(dirname "$dir")
  done
  if [[ -e "$dir/requirements.txt" || -e "$dir/Pipfile" || -e "$dir/setup.py" ]]; then
    echo "$dir"
  else
    echo ""
  fi
}

function find_package_json {
  local dir=$1
  while [[ "$dir" != "" && ! -e "$dir/package.json" ]]; do
    dir=${dir%/*}
  done
  [[ -e "$dir/package.json" ]] && echo "$dir" || echo ""
}

find_java_project_root() {
  local dir=$1
  while [[ "$dir" != "/" && ! -e "$dir/pom.xml" && ! -e "$dir/build.gradle" && ! -e "$dir/build.gradle.kts" ]]; do
    dir=$(dirname "$dir")
  done
  if [[ -e "$dir/pom.xml" || -e "$dir/build.gradle" || -e "$dir/build.gradle.kts" ]]; then
    echo "$dir"
  else
    echo ""
  fi
}

find_csharp_project_root() {
  local dir=$1
  while [[ "$dir" != "/" && ! -e "$dir/*.csproj" ]]; do
    dir=$(dirname "$dir")
  done
  if [[ -e "$dir/*.csproj" ]]; then
    echo "$dir"
  else
    echo ""
  fi
}

function env_info {

  # Check if the current directory is part of a git repository
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then

    py_project_dir=$(find_python_project_root "$(pwd)")
    node_project_dir=$(find_package_json "$(pwd)")
    java_project_dir=$(find_java_project_root "$(pwd)")
    csharp_project_dir=$(find_csharp_project_root "$(pwd)")

    #---------------------------------------------------------------------------
    # PYTHON
    #---------------------------------------------------------------------------

    if [[ -n "$py_project_dir" ]]; then
      local env_type=""
      local env_path=""
      local frameworks_detected=()

      # Determine environment type
      if [[ -n "$VIRTUAL_ENV" ]]; then
        environment="(VirtualEnv:$VIRTUAL_ENV) "
      elif [[ -n "$CONDA_PREFIX" ]]; then
        environment="(Conda:$CONDA_PREFIX) "
      fi

      # Check for Python frameworks

      # API frameworks

      if python -c "import django" &>/dev/null; then
        frameworks_detected+=('Django') # Django is a high-level Python web framework that encourages rapid development and clean, pragmatic design.
      fi
      if python -c "import flask" &>/dev/null; then
        frameworks_detected+=('Flask') # Flask is a lightweight WSGI web application framework
      fi
      if python -c "import fastapi" &>/dev/null; then
        frameworks_detected+=('FastAPI') # FastAPI is a modern, fast (high-performance), web framework for building APIs with Python 3.6+ based on standard Python type hints.
      fi
      if python -c "import falcon" &>/dev/null; then
        frameworks_detected+=('Falcon') # Minimalist web framework
      fi
      if python -c "import hug" &>/dev/null; then
        frameworks_detected+=('Hug') # Hug aims to make developing Python driven APIs as simple as possible, but no simpler.
      fi
      if python -c "import pyramid" &>/dev/null; then
        frameworks_detected+=('Pyramid') # Pyramid is a lightweight Python web framework aimed at taking small web apps into big web apps.
      fi

      # Desktop frameworks

      if python -c "import pyqt5" &>/dev/null; then
        frameworks_detected+=('PyQt5') # PyQt5 is a comprehensive set of Python bindings for Qt v5.
      fi
      if python -c "import pygtk" &>/dev/null; then
        frameworks_detected+=('PyGTK') # PyGTK lets you to easily create programs with a graphical user interface using the Python programming language.
      fi
      if python -c "import tkinter" &>/dev/null; then
        frameworks_detected+=('Tkinter') # Tkinter is Python's standard GUI (Graphical User Interface) package.
      fi
      if python -c "import wxpython" &>/dev/null; then
        frameworks_detected+=('wxPython') # wxPython is a blending of the wxWidgets C++ class library with the Python programming language.
      fi
      
      # Mobile frameworks

      if python -c "import kivy" &>/dev/null; then
        frameworks_detected+=('Kivy') # Kivy is an open source Python library for developing multitouch applications.
      fi
      if python -c "import beeware" &>/dev/null; then
        frameworks_detected+=('BeeWare') # BeeWare is a collection of tools and libraries for building native user interfaces.
      fi
      if python -c "import pybee" &>/dev/null; then
        frameworks_detected+=('PyBee') # PyBee is a collection of tools and libraries for building native user interfaces.
      fi

      # Data science frameworks

      if python -c "import numpy" &>/dev/null; then
        frameworks_detected+=('NumPy') # NumPy is the fundamental package for scientific computing with Python.
      fi
      if python -c "import pandas" &>/dev/null; then
        frameworks_detected+=('Pandas') # Pandas is a fast, powerful, flexible and easy to use open source data analysis and data manipulation library built on top of Python.
      fi
      if python -c "import matplotlib" &>/dev/null; then
        frameworks_detected+=('Matplotlib') # Matplotlib is a comprehensive library for creating static, animated, and interactive visualizations in Python.
      fi
      if python -c "import seaborn" &>/dev/null; then
        frameworks_detected+=('Seaborn') # Seaborn is a Python data visualization library based on matplotlib.
      fi
      if python -c "import scikit-learn" &>/dev/null; then
        frameworks_detected+=('Scikit-learn') # Scikit-learn is a free software machine learning library for the Python programming language.
      fi
      if python -c "import tensorflow" &>/dev/null; then
        frameworks_detected+=('TensorFlow') # TensorFlow is an end-to-end open source platform for machine learning.
      fi
      if python -c "import keras" &>/dev/null; then
        frameworks_detected+=('Keras') # Keras is an open-source deep learning library written in Python.
      fi
      if python -c "import pytorch" &>/dev/null; then
        frameworks_detected+=('PyTorch') # PyTorch is an open source machine learning library based on the Torch library.
      fi
      
      # Machine learning frameworks
      
      if python -c "import xgboost" &>/dev/null; then
        frameworks_detected+=('XGBoost') # XGBoost is an optimized distributed gradient boosting library designed to be highly efficient, flexible and portable.
      fi
      if python -c "import lightgbm" &>/dev/null; then
        frameworks_detected+=('LightGBM') # LightGBM is a gradient boosting framework that uses tree based learning algorithms.
      fi
      if python -c "import catboost" &>/dev/null; then
        frameworks_detected+=('CatBoost') # CatBoost is a high-performance open-source library for gradient boosting on decision trees.
      fi
      if python -c "import h2o" &>/dev/null; then
        frameworks_detected+=('H2O') # H2O is a free, open-source machine learning platform that offers a range of tools for data analysis.
      fi
      if python -c "import mlflow" &>/dev/null; then
        frameworks_detected+=('MLflow') # MLflow is an open source platform for managing the end-to-end machine learning lifecycle.
      fi
      if python -c "import dvc" &>/dev/null; then
        frameworks_detected+=('DVC') # DVC is an open-source version control system for machine learning projects.
      fi
      if python -c "import kedro" &>/dev/null; then
        frameworks_detected+=('Kedro') # Kedro is a workflow development tool that helps you build data pipelines that are robust, scalable, deployable, reproducible and versioned.
      fi
      if python -c "import airflow" &>/dev/null; then
        frameworks_detected+=('Airflow') # Apache Airflow is a platform to programmatically author, schedule and monitor workflows.
      fi
      if python -c "import prefect" &>/dev/null; then
        frameworks_detected+=('Prefect') # Prefect is a new workflow management system, designed for modern infrastructure and powered by the open-source Prefect Core workflow engine.
      fi
      if python -c "import apache_beam" &>/dev/null; then
        frameworks_detected+=('Apache Beam') # Apache Beam is an open source, unified model and set of language-specific SDKs for defining and executing data processing workflows, and also data ingestion and integration flows.
      fi
      if python -c "import apache_spark" &>/dev/null; then
        frameworks_detected+=('Apache Spark') # Apache Spark is a unified analytics engine for big data processing, with built-in modules for streaming, SQL, machine learning and graph processing.
      fi
      if python -c "import dask" &>/dev/null; then
        frameworks_detected+=('Dask') # Dask is a flexible parallel computing library for analytics.
      fi
      if python -c "import ray" &>/dev/null; then
        frameworks_detected+=('Ray') # Ray is a fast and simple framework for building and running distributed applications.
      fi
      if python -c "import vaex" &>/dev/null; then
        frameworks_detected+=('Vaex') # Vaex is a high performance Python library for lazy Out-of-Core DataFrames.
      fi
      if python -c "import modin" &>/dev/null; then
        frameworks_detected+=('Modin') # Modin is a library that scales pandas workflows by changing a single line of code.
      fi
      if python -c "import polars" &>/dev/null; then
        frameworks_detected+=('Polars') # Polars is a blazingly fast DataFrame library implemented in Rust and leveraging Apache Arrow.
      fi
      if python -c "import datatable" &>/dev/null; then
        frameworks_detected+=('Datatable') # Datatable is a Python library for manipulating 1 billion rows of data.
      fi
      if python -c "import dabl" &>/dev/null; then
        frameworks_detected+=('Dabl') # Dabl is a library to make machine learning models easier to use.
      fi
      if python -c "import tpot" &>/dev/null; then
        frameworks_detected+=('TPOT') # TPOT is a Python Automated Machine Learning tool that optimizes machine learning pipelines using genetic programming.
      fi
      if python -c "import auto_ml" &>/dev/null; then
        frameworks_detected+=('AutoML') # AutoML is a library for automated machine learning.
      fi
      if python -c "import h2o" &>/dev/null; then
        frameworks_detected+=('H2O') # H2O is a free, open-source machine learning platform that offers a range of tools for data analysis.
      fi

      # Format output separated with commas
      local frameworks_string=":${frameworks_detected[@]}"

      echo %F{$Yellow%}$environment'Python'$frameworks_string%f' '

    #---------------------------------------------------------------------------
    # NODE.JS
    #---------------------------------------------------------------------------

    elif [[ -n "$node_project_dir" ]]; then

      package_json="$node_project_dir/package.json"

      local package_json=$1
      if [[ -f "$package_json" ]]; then
        # Read package.json contents
        local contents=$(cat "$package_json")
        local frameworks_detected=()

        # Check for frameworks

        # Front-end frameworks

        echo $contents | grep -q '"react"' && frameworks_detected+=('React')

        echo $contents | grep -q '"next"' && frameworks_detected+=('Next.js')
        echo $contents | grep -q '"gatsby"' && frameworks_detected+=('Gatsby')
        echo $contents | grep -q '"remix"' && frameworks_detected+=('Remix')

        echo $contents | grep -q '"@angular/core"' && frameworks_detected+=('Angular')
        echo $contents | grep -q '"vue"' && frameworks_detected+=('Vue.js')
        echo $contents | grep -q '"nuxt"' && frameworks_detected+=('Nuxt.js')
        echo $contents | grep -q '"svelte"' && frameworks_detected+=('Svelte')
        echo $contents | grep -q '"svelte-kit"' && frameworks_detected+=('SvelteKit')
        echo $contents | grep -q '"solid-js"' && frameworks_detected+=('SolidJS')
        echo $contents | grep -q '"lit"' && frameworks_detected+=('Lit')
        echo $contents | grep -q '"qwik"' && frameworks_detected+=('Qwik')

        # Back-end frameworks

        echo $contents | grep -q '"express"' && frameworks_detected+=('Express')
        echo $contents | grep -q '"nestjs"' && frameworks_detected+=('NestJS')
        echo $contents | grep -q '"fastify"' && frameworks_detected+=('Fastify')
        echo $contents | grep -q '"koa"' && frameworks_detected+=('Koa')
        echo $contents | grep -q '"hapi"' && frameworks_detected+=('Hapi')
        echo $contents | grep -q '"sails"' && frameworks_detected+=('Sails')
        echo $contents | grep -q '"adonis"' && frameworks_detected+=('AdonisJS')
        echo $contents | grep -q '"feathers"' && frameworks_detected+=('Feathers')
        echo $contents | grep -q '"loopback"' && frameworks_detected+=('LoopBack')
        echo $contents | grep -q '"strapi"' && frameworks_detected+=('Strapi') # Headless CMS
        echo $contents | grep -q '"meteor"' && frameworks_detected+=('Meteor')
        echo $contents | grep -q '"keystone"' && frameworks_detected+=('Keystone')
        echo $contents | grep -q '"blitz"' && frameworks_detected+=('Blitz')
        echo $contents | grep -q '"redwood"' && frameworks_detected+=('Redwood')
        echo $contents | grep -q '"sapper"' && frameworks_detected+=('Sapper')
        echo $contents | grep -q '"deno"' && frameworks_detected+=('Deno')

        # API frameworks

        echo $contents | grep -q '"graphql"' && frameworks_detected+=('GraphQL')
        echo $contents | grep -q '"apollo-server"' && frameworks_detected+=('Apollo Server')
        echo $contents | grep -q '"prisma"' && frameworks_detected+=('Prisma')
        echo $contents | grep -q '"hasura"' && frameworks_detected+=('Hasura')
        echo $contents | grep -q '"postgraphile"' && frameworks_detected+=('PostGraphile')
        echo $contents | grep -q '"type-graphql"' && frameworks_detected+=('TypeGraphQL')
        echo $contents | grep -q '"nexus"' && frameworks_detected+=('Nexus')
        echo $contents | grep -q '"graphile"' && frameworks_detected+=('Graphile')
        echo $contents | grep -q '"swagger"' && frameworks_detected+=('Swagger')

        # Mobile frameworks
        echo $contents | grep -q '"react-native"' && frameworks_detected+=('React Native')
        echo $contents | grep -q '"expo"' && frameworks_detected+=('Expo')
        echo $contents | grep -q '"capacitor"' && frameworks_detected+=('Capacitor')
        echo $contents | grep -q '"ionic"' && frameworks_detected+=('Ionic')
        echo $contents | grep -q '"cordova"' && frameworks_detected+=('Cordova')

        # Desktop frameworks

        echo $contents | grep -q '"electron"' && frameworks_detected+=('Electron')

        # TypeScript
        echo $contents | grep -q '"typescript"' && frameworks_detected+=('TypeScript')

        # Convert array to comma-separated string and output
        # local frameworks_string=$(
        #   IFS=,
        #   echo "${frameworks_detected[*]}"
        # )

      fi

      # Format output

      [[ -n "$frameworks_detected" ]] && frameworks_strings=":${frameworks_detected[@]}"
      echo %F{$Yellow%}'JS'$frameworks_string%f' '

    #---------------------------------------------------------------------------
    # JAVA
    #---------------------------------------------------------------------------

    elif [[ -n "$java_project_dir" ]]; then

      java_project=""
      java_version=""
      java_frameworks=()

      # Check for Maven or Gradle
      if [[ -f "$java_project_dir/pom.xml" ]]; then
        java_project="Maven"
        # Extract Java version from Maven pom.xml
        local java_version=$(grep -m1 '<java.version>' "$java_project_dir/pom.xml" | sed -e 's/.*<java.version>\(.*\)<\/java.version>.*/\1/')
      elif [[ -f "$java_project_dir/build.gradle" || -f "$java_project_dir/build.gradle.kts" ]]; then
        java_project="Gradle"
        # Gradle's Java version might be set in various places, this is a simple guess:
        local java_version=$(grep -m1 'sourceCompatibility' "$java_project_dir/build.gradle" | awk '{print $2}' | tr -d "'")
        # If java_version is empty, try the Kotlin DSL
        if [[ -z "$java_version" ]]; then
          local java_version=$(grep -m1 'sourceCompatibility' "$java_project_dir/build.gradle.kts" | awk '{print $2}' | tr -d "'")
        fi
      fi

      # Check for Java frameworks like Spring Boot or Spring MVC by searching for dependencies
      local frameworks_found=()
      local build_files=("$project_root/pom.xml" "$project_root/build.gradle" "$project_root/build.gradle.kts")
      local project_type=""

      # Web
      [[ $(grep -q 'spring-boot' $build_files 2>/dev/null) ]] && frameworks_found+=("Spring Boot") && project_type="Web"
      [[ $(grep -q 'spring-webmvc' $build_files 2>/dev/null) ]] && frameworks_found+=("Spring MVC") && project_type="Web"
      [[ $(grep -q 'quarkus' $build_files 2>/dev/null) ]] && frameworks_found+=("Quarkus") && project_type="Web"
      [[ $(grep -q 'vertx' $build_files 2>/dev/null) ]] && frameworks_found+=("Vert.x") && project_type="Web"
      [[ $(grep -q 'jhipster' $build_files 2>/dev/null) ]] && frameworks_found+=("JHipster") && project_type="Web"
      [[ $(grep -q 'ktor' $build_files 2>/dev/null) ]] && frameworks_found+=("Ktor") && project_type="Web"
      [[ $(grep -q 'jsf' $build_files 2>/dev/null) ]] && frameworks_found+=("JavaServer Faces") && project_type="Web"
      [[ $(grep -q 'struts' $build_files 2>/dev/null) ]] && frameworks_found+=("Struts") && project_type="Web"
      [[ $(grep -q 'play' $build_files 2>/dev/null) ]] && frameworks_found+=("Play Framework") && project_type="Web"
      [[ $(grep -q 'grails' $build_files 2>/dev/null) ]] && frameworks_found+=("Grails") && project_type="Web"
      [[ $(grep -q 'helidon' $build_files 2>/dev/null) ]] && frameworks_found+=("Helidon") && project_type="Web"
      [[ $(grep -q 'micronaut' $build_files 2>/dev/null) ]] && frameworks_found+=("Micronaut") && project_type="Web"
      [[ $(grep -q 'hibernate' $build_files 2>/dev/null) ]] && frameworks_found+=("Hibernate ORM") && project_type="Web"
      [[ $(grep -q 'vaadin' $build_files 2>/dev/null) ]] && frameworks_found+=("Vaadin") && project_type="Web"
      [[ $(grep -q 'javafx' $build_files 2>/dev/null) ]] && frameworks_found+=("JavaFX") && project_type="Web"

      # Desktop
      [[ $(grep -q 'javafx' $build_files 2>/dev/null) ]] && frameworks_found+=("JavaFX") && project_type="Desktop"
      [[ $(grep -q 'swing' $build_files 2>/dev/null) ]] && frameworks_found+=("Swing") && project_type="Desktop"
      [[ $(grep -q 'awt' $build_files 2>/dev/null) ]] && frameworks_found+=("AWT") && project_type="Desktop"

      # Mobile
      [[ $(grep -q 'android' $build_files 2>/dev/null) ]] && frameworks_found+=("Android") && project_type="Android"
      [[ $(grep -q 'javafx' $build_files 2>/dev/null) ]] && frameworks_found+=("JavaFX") && project_type="Android"

      # If the project is a Web Api, detect if it is REST API, GraphQL or just Web API
      [[ $(grep -q 'spring-boot' $build_files 2>/dev/null) ]] && [[ $(grep -q 'spring-webmvc' $build_files 2>/dev/null) ]] && [[ $(grep -q 'graphql' $build_files 2>/dev/null) ]] && frameworks_found+=("GraphQL") && project_type="GraphQL"
      [[ $(grep -q 'spring-boot' $build_files 2>/dev/null) ]] && [[ $(grep -q 'spring-webmvc' $build_files 2>/dev/null) ]] && [[ $(grep -q 'swagger' $build_files 2>/dev/null) ]] && frameworks_found+=("Swagger") && project_type="REST API"
      [[ $(grep -q 'spring-boot' $build_files 2>/dev/null) ]] && [[ $(grep -q 'spring-webmvc' $build_files 2>/dev/null) ]] && frameworks_found+=("Web API") && project_type="Web API"

      # Format output
      
      [[ -n "$java_project" ]] && java_project=":$java_project"
      [[ -n "$java_version" ]] && java_version=":$java_version"
      [[ -n "$project_type" ]] && project_type=":$project_type"

      [[-n "$frameworks_found" ]] && frameworks_string=":${frameworks_found[@]}"
      
      echo %F{$Yellow%}Java$java_project$java_version$project_type$frameworks_string%f' '

    #---------------------------------------------------------------------------
    # C#
    #---------------------------------------------------------------------------

    elif [[ -n "$cshar_project_dir" ]]; then
      echo "Inside a C# Git project at: $cshar_project_dir"
      local csproj_file=$(find "$cshar_project_dir" -name "*.csproj" | head -n 1)

      if [[ -n "$csproj_file" ]]; then
        # Using xmllint to parse .csproj XML content for target framework and package references
        # target_framework contains the target framework version, e.g. net5.0
        local target_framework=$(xmllint --xpath "string(//Project/PropertyGroup/TargetFramework)" "$csproj_file")

        # Detecting various frameworks and technologies
        local package_references=$(xmllint --xpath "//Project/ItemGroup/PackageReference/@Include" "$csproj_file" 2>/dev/null | tr ' ' '\n' | grep -oP 'Include="\K[^"]+')

        local frameworks_detected=()
        local project_type=""  # Detect if it is a REST API project, Web API project, GraphQL or a Blazor project
        echo $package_references | grep -q 'Microsoft.AspNetCore.App' && frameworks_detected+=('ASP.NET Core') && project_type="Web API"
        echo $package_references | grep -q 'Microsoft.NET.Sdk.Web' && frameworks_detected+=('ASP.NET')
        echo $package_references | grep -q 'Microsoft.AspNetCore.Blazor' && frameworks_detected+=('Blazor') && project_type="Blazor"
        echo $package_references | grep -q 'Xamarin.Forms' && frameworks_detected+=('Xamarin')
        echo $package_references | grep -q 'Microsoft.Maui' && frameworks_detected+=('.NET MAUI')
        echo $package_references | grep -q 'Uno.' && frameworks_detected+=('Uno Platform')
        echo $package_references | grep -q 'Avalonia' && frameworks_detected+=('Avalonia')
        echo $package_references | grep -q 'Prism' && frameworks_detected+=('Prism')
        echo $package_references | grep -q 'HotChocolate' && frameworks_detected+=('HotChocolate') && project_type="GraphQL"
        echo $package_references | grep -q 'GraphQL' && frameworks_detected+=('GraphQL') && project_type="GraphQL"
        echo $package_references | grep -q 'Swashbuckle.AspNetCore' && frameworks_detected+=('Swagger') && project_type="REST API"

        # Format output
        [[-n "$project_type" ]] && project_type=":$project_type"
        [[-n "$target_framework" ]] && target_framework=":$target_framework"
        [[-n "$frameworks_detected" ]] && frameworks_string=":${frameworks_detected[@]}"

        echo %F{$Yellow%}'C#'$target_framework$frameworks_string$project_type%f' '

      fi

    fi

  fi

}

# ------------------------------------------------------------------------------
# Git Branch Information
# ------------------------------------------------------------------------------

PR_GIT_UPDATE=1 # force git prompt update on new shell

# zstyle is used to configure its output
# vcs_info is a function that checks for the current branch/status of the repo

# enable VCS systems you use
zstyle ':vcs_info:*' enable git svn hg

# check-for-changes can be really slow.
# you should disable it, if you work with large repositories
zstyle ':vcs_info:*:prompt:*' check-for-changes true

# set formats
# %b - branchname
# %u - unstagedstr (see below)
# %c - stagedstr (see below)
# %a - action (e.g. rebase-i)
# %R - repository path
# %S - path in the repository
PR_RST="%f"                              # reset color
FMT_BRANCH="(%F{$Cyan%}%b%u%c${PR_RST})" # branchname unstagedstr stagedstr
FMT_ACTION="(%F{$Green%}%a${PR_RST})"    # action
FMT_UNSTAGED="%F{$Yellow%}●"             # unstagedstr
FMT_STAGED="%F{$Green%}●"                # stagedstr

zstyle ':vcs_info:*:prompt:*' unstagedstr "${FMT_UNSTAGED}"
zstyle ':vcs_info:*:prompt:*' stagedstr "${FMT_STAGED}"
zstyle ':vcs_info:*:prompt:*' actionformats "${FMT_BRANCH}${FMT_ACTION}"
zstyle ':vcs_info:*:prompt:*' formats "${FMT_BRANCH}"
zstyle ':vcs_info:*:prompt:*' nvcsformats ""

function steeef_preexec { # preexec is called before each command
  case "$2" in
  *git*)            # git
    PR_GIT_UPDATE=1 # force git prompt update
    ;;
  *hub*) # extension for git when workikng with github
    PR_GIT_UPDATE=1
    ;;
  *hg*) # mercurial
    PR_GIT_UPDATE=1
    ;;
  *svn*) # apache SVN
    PR_GIT_UPDATE=1
    ;;
  esac
}
# add preexec hook to zsh: the function above is called before each command
add-zsh-hook preexec steeef_preexec

function steeef_chpwd {
  PR_GIT_UPDATE=1
}
# add preexec hook to zsh: chpwd is called when the current directory is changed
add-zsh-hook chpwd steeef_chpwd

function steeef_precmd {
  if [[ -n "$PR_GIT_UPDATE" ]]; then # if PR_GIT_UPDATE is not empty
    # check for untracked files or updated submodules, since vcs_info doesn't
    if git ls-files --other --exclude-standard 2>/dev/null | grep -q "."; then
      PR_GIT_UPDATE=1
      FMT_BRANCH="(%F{$Cyan%}%b%u%c%F{$Red%}●${PR_RST})"
    else
      FMT_BRANCH="(%F{$Cyan%}%b%u%c${PR_RST})"
    fi
    zstyle ':vcs_info:*:prompt:*' formats "${FMT_BRANCH} "

    vcs_info 'prompt' # update vcs_info
    PR_GIT_UPDATE=    # empty PR_GIT_UPDATE
  fi
}
# add precmd hook to zsh: precmd is called before each prompt
add-zsh-hook precmd steeef_precmd

# ------------------------------------------------------------------------------
# PROMPT
# ------------------------------------------------------------------------------

# Prompt Layout:
# <env_info> <user>@<host>:<current_dir> <git_branch> <git_action>
function user_and_host {
  echo "%F{$Green%}%n@%m%f "
}
function current_dir {
  # Define colors
  local normal_color="%F{$LightBlue%}"
  local highlight_color="%F{$Yellow%}"

  # Find the project root of a git repository
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    Project_Root=$(git rev-parse --show-toplevel)
  fi
  local project_folder=$(basename "$Project_Root")

  # Break the current path into an array of directories
  local path_array=("${(@s:/:)PWD}")

  # Initialize the new path display
  local new_path=""

  # Iterate over each part of the path
  new_path+=$normal_color
  for dir in $path_array; do
    if [[ "$dir" == "$project_folder" ]]; then
      # Highlight the project folder
      new_path+="${normal_color}/${highlight_color}${dir}%f${normal_color}"
    else
      # Add normally colored part
      new_path+="/${dir}"
    fi
    if [[ $new_path == $normal_color$(eval echo ~) ]]; then
      new_path=$normal_color'~'
    fi
  done
  new_path+='%f'

  # Echo the path with possibly highlighted directory
  echo "%F{$normal_color%}${new_path}%f"

}

function git_branch_and_action {
  echo " $vcs_info_msg_0_"
}
function current_time {
  echo "%F{$LightMagenta%}%*%f" # current time with milliseconds
}
function prompt_end {
  echo "$"
}

# Prompt String / Prompt Layout

PROMPT=$'$(current_time) $(env_info)$(user_and_host)$(current_dir)$(git_branch_and_action)\n$(prompt_end) '
