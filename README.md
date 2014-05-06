docker-ipython
==============

Run [IPython](http://ipython.org) inside [Docker](http://www.docker.io).
This fork uses Archlinux instead of ubuntu. 
Python libs are installed using pacman if possible and pip if not (no aur packages). 

####Includes:
* [NLTK](http://nltk.org)
* [Pandas](http://pandas.pydata.org)
* [NumPy](http://www.numpy.org)
* [SciPy](http://scipy.org) 
* [SymPy](http://sympy.org)
* [Cython](http://cython.org)
* [Parakeet](http://www.parakeetpython.com/)
* [Biopython](http://biopython.org)
* [Rmagic](http://ipython.org/ipython-doc/dev/config/extensions/rmagic.html)
* [Scikit-learn](http://scikit-learn.org/stable/)
* [OpenCV](http://opencv.org)
* see Dockerfile for more

####Instructions
1. Add a SSL certificate using ```openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout mycert.pem -out mycert.pem``` or use a proper one if you can.
2. Add your public key as id_rsa.pub (or ```touch id_rsa.pub``` if you don't want to use ssh)
2. Build Docker image using the using ```build``` script.  This can take a long time, ~30mins.  Luckily this step only has to done once(or whenever you change the Dockerfile).
3. Create and shell into new Docker container using ```shell``` script
4. Start IPython Notebook in the container using ```supervisord&```
5. Point your brower to ```http://<your host name>:8888```, default login password is 'password'

To run in background execute ```./start [notebook_path] [ip]``` and notebook_path will be mounted as the notebook folder of ipython and the ports 8888 and 23 will be published on ip (default 0.0.0.0, use 127.0.0.1 for local testing)

#### Background mode
In background or using supervisord the user ipy is used to run the ipython notebook. The /home/ipy/.python contains the configuration options that were copied from the profile_nbserver.

#### Enable or change password authentication
In order to enable password authentication, modify the configuration in this [file](http://github.com/lluiscanet/docker-ipython/blob/master/profile_nbserver/ipython_notebook_config.py)
by commenting out the line
```c.NotebookApp.password = u'sha1:01dc1e3ecfb8:cc539c4fcc2ef3d751e4a20d918f761fd6704798'```

To change the password

1. Get your hashed password by executing in your python client the following: 

```
In [1]: from IPython.lib import passwd
In [2]: passwd()
Enter password:
Verify password:
```

2. Replace the line in config [file](http://github.com/lluiscanet/docker-ipython/blob/master/profile_nbserver/ipython_notebook_config.py) with 
```c.NotebookApp.password = u'sha1:yourhashedpassword'``` 

