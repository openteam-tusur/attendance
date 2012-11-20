# encoding: utf-8

require 'spec_helper'

describe Ability do
  let(:fsu) { Faculty.create(:title => 'Факультет систем управления') }
  let(:rkf) { Faculty.create(:title => 'Факультет радиоконструирования') }
  let(:g_fsu) { fsu.groups.create(:number => '433-2') }
  let(:g_rkf) { rkf.groups.create(:number => '133-2') }
  let(:s_g_fsu) { g_fsu.students.create(:surname => 'Иванов') }
  let(:s_g_rkf) { g_rkf.students.create(:surname => 'Петров') }
  let(:l_fsu) { g_fsu.lessons.create }
  let(:l_rkf) { g_rkf.lessons.create }
  let(:p_s_g_fsu) { Presence.create(:lesson_id => l_fsu.id, :student_id => s_g_fsu.id) }
  let(:p_s_g_rkf) { Presence.create(:lesson_id => l_rkf.id, :student_id => s_g_rkf.id) }

  context 'менеджер' do
    context 'корневого контекста' do
      subject { ability_for(manager) }

      context 'управление контекстами' do
        it { should be_able_to(:manage, :all) }
      end
    end
  end

  context 'Сотрудник учебного управления' do
    subject { ability_for(study_department_worker) }

    context 'управление контекстами' do
      it { should_not be_able_to(:manage, :all) }
    end

    context 'просмотр статистики по факультетам' do
      it { should be_able_to(:read, :university_statistics) }
    end
  end

  context 'Сотрудник факультета' do
    subject { ability_for(faculty_worker_of(fsu)) }

    context 'управление контекстами' do
      it { should_not be_able_to(:manage, :all) }
    end

    context 'просмотр статистики по факультетам' do
      it { should_not be_able_to(:read, :university_statistics) }
    end

    context 'просмотр статистики факультета' do
      it { should     be_able_to(:read, fsu) }
      it { should_not be_able_to(:read, rkf) }
    end

    context 'просмотр статистики группы' do
      it { should     be_able_to(:read, g_fsu) }
      it { should_not be_able_to(:read, g_rkf) }
    end

    context 'управлять посещаемостью группы' do
      it { should     be_able_to(:manage, p_s_g_fsu) }
      it { should     be_able_to(:switch_state, l_fsu) }
      it { should_not be_able_to(:manage, p_s_g_rkf) }
      it { should_not be_able_to(:switch_state, l_rkf) }
    end
  end

  context 'Староста группы' do
    subject { ability_for(group_leader_of(g_fsu)) }

    context 'управление контекстами' do
      it { should_not be_able_to(:manage, :all) }
    end

    context 'просмотр статистики по факультетам' do
      it { should_not be_able_to(:read, :university_statistics) }
    end

    context 'просмотр статистики факультета' do
      it { should_not be_able_to(:read, fsu) }
      it { should_not be_able_to(:read, rkf) }
    end

    context 'просмотр статистики группы' do
      it { should_not be_able_to(:read, g_fsu) }
      it { should_not be_able_to(:read, g_rkf) }
    end

    context 'управлять посещаемостью группы' do
      it { should     be_able_to(:manage, p_s_g_fsu) }
      it { should     be_able_to(:switch_state, l_fsu) }
      it { should_not be_able_to(:manage, p_s_g_rkf) }
      it { should_not be_able_to(:switch_state, l_rkf) }
    end
  end
end
