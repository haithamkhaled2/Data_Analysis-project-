from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By
from bs4 import BeautifulSoup as bs
import urllib.parse 
import time
import csv

job_details = []

def Wuzzuf_all_pages(topic):
    service = Service(ChromeDriverManager().install())
    browser = webdriver.Chrome(service=service)
    
    try:
        encoding_topic = urllib.parse.quote(topic)
        base_url = f'https://wuzzuf.net/search/jobs/?q={encoding_topic}&a=navbg'
        page_number = 0

        while True:
            
            if page_number == 0:
                url = base_url
            else:
                url = f'{base_url}&start={page_number}'
                
            browser.get(url)
            time.sleep(5)

            products_list = browser.find_elements(By.CLASS_NAME, "css-1gatmva")

            if len(products_list) == 0:
                print("No more jobs found. Stopping.")
                break

            for product in products_list:
                html = product.get_attribute('outerHTML')
                soup = bs(html, 'html.parser')

                try:
                    job_title = soup.find('h2', {'class': 'css-m604qf'}).text
                except:
                    job_title = 'N/A'

                try:
                    company_name = soup.find('a', {'class': 'css-17s97q8'}).text
                except:
                    company_name = 'N/A'

                try:
                    location_name = soup.find('span', {'class': 'css-5wys0k'}).text
                except:
                    location_name = 'N/A'

                try:
                    status = soup.find('div', {'class': 'css-1lh32fc'}).text
                except:
                    status = 'N/A'

                try:
                    skills = soup.find('div', {'class': 'css-y4udm8'}).text
                except:
                    skills = 'N/A'

                job_details.append({
                    'Job Title': job_title,
                    'Company Name': company_name,
                    'Location': location_name,
                    'Status': status,
                    'Skills Requirements': skills,
                })
            
            print(f"Page {page_number * 1} scraped.")
            print('Count of Jobs : ',len(job_details))
            page_number += 1

    except Exception as e:
        print(f"Error: {e}")

    finally:
        browser.quit()

def save_to_csv():
    if len(job_details) == 0:
        print("No data to save.")
        return

    file_name = 'Wuzzuf Jobs Opportunity.csv'
    keys = job_details[0].keys()
    with open(file_name, 'w', newline='', encoding='UTF-8') as output_file:
        dict_writer = csv.DictWriter(output_file, keys)
        dict_writer.writeheader()
        dict_writer.writerows(job_details)

    print("CSV file created successfully.")



topic = input("Enter job topic to search on Wuzzuf (e.g., Python, Data Analyst): ")
Wuzzuf_all_pages(topic)
save_to_csv()
