AdminUser.create(email: 'admin@example.com',
                 password: 'password',
                 password_confirmation: 'password')
2.times { FactoryBot.create :user }
FactoryBot.create :sponsor,
                   sponsor_type: SponsorType.find_by_name('Individual'),
                   branch: Branch.find_by_name('Riyadh')
FactoryBot.create :sponsor,
                   sponsor_type: SponsorType.find_by_name('Organization'),
                   organization: Organization.find_by_name('أهل الغربة وقت الكربة'),
                   branch: nil
FactoryBot.create :partner,
                   province: Province.find_by_name('Homs')
FactoryBot.create :partner,
                   province: Province.find_by_name('Aleppo')
3.times { FactoryBot.create :orphan }
