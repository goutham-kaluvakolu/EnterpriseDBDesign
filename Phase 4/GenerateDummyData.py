from faker import Faker
import random
import string
import datetime
import numpy as np


Faker.seed(4321)
fake = Faker(locale='en_US')

# no of tuples in each table is decided here

num_acc = 100
num_admins = 4
num_users = num_acc-num_admins
num_sellers = int(num_acc/4)
num_buyers = num_users-num_sellers

# all the dates in db are b/w these days
# Generate a random date between 2019-01-01 and 2022-12-31
start_date = datetime.date(2019, 1, 1)
end_date = datetime.date(2022, 12, 31)
delta = (end_date - start_date).days

def get_name(name):
    letters = string.ascii_lowercase
    x = ''.join(random.choice(letters) for i in range(4))
    return name+x

def get_password():
    letters = string.ascii_lowercase
    return ''.join(random.choice(letters) for i in range(10))

def get_email(uname):
    return uname+'@gmail.com'

def get_phone():
    return ''.join(str(random.randint(0, 9)) for i in range(10))

def get_gender():
    return random.choice(['Male', 'Female', 'Other'])

# variables for future use
user_names = []
users_reg_dates = []
# buyer_reg
# users
# sellers_names
# buyer_names

# create accounts by num_acc variable

with open('accounts.csv', 'w') as f:

    # header
    f.write('Username, Password, Email, First_Name, Last_Name, Phone_Number\n')
    # Generate data for each row and write it to the file
    for i in range(num_acc):
        student_id = i + 1
        name = fake.name().split(" ")
        first_name = name[0]
        last_name = name[1]
        user_name = get_name(first_name)
        #primiarykey
        user_names.append(user_name)
        acc_pswd = get_password()
        user_email = get_email(name[0])
        phone_number = get_phone()
        f.write(
            f'{user_name},{acc_pswd},{user_email},{first_name},{last_name},{phone_number}\n')

print(f'Data generated for {num_acc} accounts.')


with open('admin.csv', 'w') as f:

    # Write the header row to the file
    f.write('Admin_Username, SSN, Address, Salary\n')

    # Generate data for each row and write it to the file
    ad_user_n = user_names[:4]
    for i in range(num_admins):
        ssn = fake.invalid_ssn()
        adds = fake.address()
        # can make this random
        salary = 100000
        f.write(f'{ad_user_n[i]},{ssn},{adds},{salary}\n')

print(f'Data generated for {num_admins} admins.')

with open('user.csv', 'w') as f:

    # Write the header row to the file
    f.write('Username, User_ID, Gender, Registration_Date\n')

    # Generate data for each row and write it to the file
    users = user_names[4:]
    for i in range(num_users):
        u_id = fake.iana_id()
        gender = get_gender()
        random_days = random.randint(0, delta)
        reg_date = start_date + datetime.timedelta(days=random_days)
        reg_date = reg_date.strftime('%Y-%m-%d')
        users_reg_dates.append(reg_date)
        f.write(f'{users[i]},{u_id},{gender},{reg_date}\n')

print(f'Data generated for {num_users} users.')

with open('sellers.csv', 'w') as f:
    # Write the header row to the file
    f.write('Username, Bio\n')
    # Generate data for each row and write it to the file
    n = num_sellers
    sellers_names = users[:n]
    for i in range(num_sellers):
        bio = fake.paragraph(nb_sentences=1)
        f.write(f'{sellers_names[i]},{bio}\n')

print(f'Data generated for {num_sellers} sellers.')

with open('buyers.csv', 'w') as f:

    # Write the header row to the file
    f.write('Username\n')

    # Generate data for each row and write it to the file
    n = num_sellers
    buyer_names = users[n:]
    buyer_reg = users_reg_dates[n:]
    for i in range(num_buyers):
        f.write(f'{buyer_names[i]}\n')

print(f'Data generated for {num_buyers} buyers.')

# Membership(Username, Membership_ID, End_Date, Tier)

with open('membership.csv', 'w') as f:

    # Write the header row to the file
    f.write('Username, Membership_ID, End_Date, Tier\n')

    # re ini seed for random mem id
    Faker.seed(5432)

    # Generate data for each row and write it to the file
    # n = num_sellers+1
    n=num_sellers
    buyer_names = users[n:]
    Membership_IDs = []
    End_dates = []
    tt = [0, 1, 2]
    Tier = ["Gold", "Platinum", "Diamond"]
    tier_idxs = []
    mem_map = {"Gold": 3, "Platinum": 9, "Diamond": 30}
    dic = {}
    rows=0
    for i in range(num_sellers):
        rows+=1
        Membership_ID = fake.iana_id()
        Membership_IDs.append(Membership_ID)
        random_days = random.randint(0, delta)
        End_date = start_date + datetime.timedelta(days=random_days)
        End_date = End_date.strftime('%Y-%m-%d')

        if End_date > users_reg_dates[i]:
            End_dates.append(End_date)
        else:
            End_date = users_reg_dates[i]
            End_dates.append(End_date)
        tier = random.choice(Tier)
        dic[sellers_names[i]] = mem_map[tier]
        f.write(f'{sellers_names[i]},{Membership_ID},{End_date},{tier}\n')

print(f'Data generated for {rows} membership table.')

# ProductCategory(Category_ID, Category_Name)
with open('prod_cat.csv', 'w') as f:
    
    # lets add more here if needed

    cat_names = ['Furniture', 'Kitchen', 'Bedding',
                 'Lighting', 'Storage', 'Electronics']
    # Write the header row to the file
    f.write('Category_ID, Category_Name\n')
    Faker.seed(321)
    # Generate data for each row and write it to the file
    cat_ids = []
    row=0
    for idx, val in enumerate(cat_names):
        row+=1
        cat_id = idx
        cat_ids.append(cat_id)
        f.write(f'{cat_id},{val}\n')

print(f'Data generated for {row} product cat.')

# Listing(Listing_ID, Name, Description, Price, Category_ID, Buyer_Username, Buy_Date)

with open('listing.csv', 'w') as f:
    # Write the header row to the file
    f.write(
        'Listing_ID, Name, Description, Price, Category_ID, Buyer_Username, Buy_Date\n')
    Faker.seed(3221)

    # Generate data for each row and write it to the file
    # list of list [[],[]] inner list all lis id of perticular user outter rep users

    all_lis = []
    row=0

    for idx, val in enumerate(sellers_names):
        random.seed(123)
        g = np.random.randint(0, dic[val]+1)
        lis_ids = []

        for k in range(g):
            row+=1
            lis_id = fake.iana_id()
            lis_ids.append(lis_id)
            x = random.choice([0, 1, 2, 3, 4, 5])
            name = cat_names[x]
            des = fake.paragraph(nb_sentences=1)
            Price = random.randint(100, 1000)
            buyer = random.choice(buyer_names)
            buyer_idx = random.randint(0, len(buyer_names)-1)
            b_name = buyer_names[buyer_idx]
            reg_date = buyer_reg[buyer_idx]
            random_days = random.randint(0, delta)

            b_date = start_date + datetime.timedelta(days=random_days)
            b_date = b_date.strftime('%Y-%m-%d')
            if reg_date > b_date:
                b_date = reg_date

            f.write(f'{lis_id},{name},{des},{Price},{x},{b_name},{b_date}\n')
        all_lis.append(lis_ids)
print(f'Data generated for {row} listings.')


with open('sell-post.csv', 'w') as f:

    seller_reg_date = users_reg_dates[:num_sellers]
    # Write the header row to the file
    f.write('Username, Listing_ID, Post_Date\n')
    # Generate data for each row and write it to the file
    lis_ids = []
    row=0
    for idx, j in enumerate(all_lis):
        for i in j:
            row+=1
            random_days = random.randint(0, delta)
            date = start_date + datetime.timedelta(days=random_days)
            date = date.strftime('%Y-%m-%d')
            if date < seller_reg_date[idx]:
                date = seller_reg_date[idx]

            f.write(f'{sellers_names[idx]},{i},{date}\n')
print(f'Data generated for {row} sell-post.')

# Review(Review_ID, Review_Text, Rating, Successful_Transaction, Listing_ID, Reviewer_Username, Reviewee_Username)

with open('reviews.csv', 'w') as f:

    Faker.seed(678)

    # Write the header row to the file
    f.write('Review_ID, Review_Text, Rating, Successful_Transaction, Listing_ID, Reviewer_Username, Reviewee_Usernamee\n')
    # Generate data for each row and write it to the file
    lis_ids = []
    total_reviews = int(len(buyer_names)/1.5)
    reviewer = random.randint(0, total_reviews)
    row=0
    for j in range(int(total_reviews)):
        row+=1
        review_id = fake.iana_id()
        review_txt = fake.paragraph(nb_sentences=1)
        rating = random.randint(0, 5)
        buyer_id = random.randint(0, len(buyer_names)-1)
        reviewer = buyer_names[buyer_id]
        seller_id = random.randint(0, len(sellers_names)-1)
        if len(all_lis[seller_id]) != 0:
            reviewee = sellers_names[seller_id]
            x = random.randint(0, len(all_lis[seller_id])-1)
            temp_lis_id = all_lis[seller_id][x]
        else:
            seller = sellers_names[0]
            temp_lis_id = all_lis[0][0]

        f.write(
            f'{review_id},{review_txt},{rating},{temp_lis_id},{reviewer},{reviewee}\n')
        
print(f'Data generated for {row} rewiews')
